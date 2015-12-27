import React from 'react';
import {Socket} from 'phoenix';

import Message from './Message';

let socket = new Socket('/socket', {params: {token: window.userToken}});

socket.connect();

const App = React.createClass({
  propTypes: {
    broadcast: React.PropTypes.string.isRequired
  },

  getInitialState: function() {
    return {
      messages: this.props.messages
    }
  },

  componentDidMount: function() {
    let channel = socket.channel(`broadcasts:${this.props.broadcast}`, {});

    channel.on('message_new', payload => {
      let messages = this.state.messages;

      messages.unshift(payload.body);

      this.setState({
        message: messages
      });

      console.log('New message', payload);
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