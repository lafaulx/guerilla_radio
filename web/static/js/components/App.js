import React from 'react';
import {Socket} from 'phoenix';
import queryString from 'query-string';

import MessageAPI from '../api/MessageAPI';
import Message from './Message';

let socket = new Socket('/socket', {params: {token: window.userToken}});

socket.connect();

const App = React.createClass({
  getInitialState: function() {
    return {
      messages: [],
      hasNextPage: false,
      queue: []
    };
  },

  componentDidMount: function() {
    let broadcast = queryString.parse(window.location.search).broadcast;

    MessageAPI
    .getPage({
      broadcast: broadcast
    })
    .then(data => {
      let { messages } = data;
      let hasNextPage = this.hasNextPage(messages);

      this.setState({
        broadcast: broadcast,
        messages: messages,
        hasNextPage: hasNextPage
      });

      this.initSockets(broadcast);
    });
  },

  initSockets: function(broadcast) {
    const channel = socket.channel(`broadcasts:${broadcast}`, {});

    channel.on('message_new', payload => {
      let { queue } = this.state;

      queue.unshift(payload.body);

      this.setState({
        queue: queue
      });
    });

    channel.on('message_edit', payload => {
      let messages = this.state.messages;
      let editedMessage = payload.body;

      for (let i = 0; i < messages.length; i++) {
        if (messages[i].id === editedMessage.id) {
          messages[i] = editedMessage;
          break;
        }
      }

      this.setState({
        messages: messages
      });
    });

    channel.on('message_delete', payload => {
      let messages = this.state.messages;
      let deteledMessageId = payload.body.id;

      for (let i = 0; i < messages.length; i++) {
        if (messages[i].id === deteledMessageId) {
          messages.splice(i, 1);
          break;
        }
      }

      this.setState({
        messages: messages
      });
    });

    channel.join()
      .receive('ok', resp => {
        console.log('Joined successfully', resp);
      })
      .receive('error', resp => {
        console.log('Unable to join', resp);
      });
  },

  render: function() {
    let { hasNextPage, messages, queue } = this.state;
    let messageComps = messages.map(msg => <Message key={msg.id} model={msg}/>);

    return (
      <div className='App'>
        {queue.length > 0 &&
          <button className='Flusher' onClick={this.handleFlusherClick}>
            Append new messages
          </button>
        }
        {messageComps}
        {hasNextPage &&
          <button className='LoadMore' onClick={this.handleLoadMoreClick}>
            Load more
          </button>
        }
      </div>
    );
  },

  handleLoadMoreClick: function() {
    let { messages, broadcast } = this.state;
    let before = messages[messages.length - 1].ts;

    MessageAPI
    .getPage({
      broadcast: broadcast,
      before: before
    })
    .then(data => {
      let { messages: newMessages } = data;
      let joinedMessages = messages.concat(newMessages);
      let hasNextPage = this.hasNextPage(newMessages);

      this.setState({
        messages: joinedMessages,
        hasNextPage: hasNextPage
      });
    });
  },

  handleFlusherClick: function() {
    let { messages, queue } = this.state;

    this.setState({
      messages: queue.concat(messages),
      queue: []
    });
  },

  hasNextPage: function(messages) {
    return messages.length === 10;
  }
});

export default App;