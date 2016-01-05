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
      messages: []
    };
  },

  componentDidMount: function() {
    const broadcast = queryString.parse(window.location.search).broadcast;

    MessageAPI
    .getAll(broadcast)
    .then(data => {
      this.setState({
        messages: data.messages
      });

      this.initSockets(broadcast);
    });
  },

  initSockets: function(broadcast) {
    const channel = socket.channel(`broadcasts:${broadcast}`, {});

    channel.on('message_new', payload => {
      let messages = this.state.messages;

      messages.unshift(payload.body);

      this.setState({
        messages: messages
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
    let messages = this.state.messages.map(msg => <Message key={msg.id} model={msg}/>);

    return (
      <div className='App'>
        {messages}
      </div>
    );
  }
});

export default App;