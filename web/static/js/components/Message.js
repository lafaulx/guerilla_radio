import React from 'react';
import moment from 'moment';

const FORMAT = 'MMMM Do YYYY, HH:mm:ss';

const Message = React.createClass({
  propTypes: {
    model: React.PropTypes.object.isRequired
  },

  render: function() {
    let {user, text, ts} = this.props.model;

    return (
      <div className='Message'>
        <div className='Message-meta'>
          <strong>{user}</strong>
          <span>{moment.unix(ts).format(FORMAT)}</span>
        </div>
        <div className='Message-text' dangerouslySetInnerHTML={{__html: text}}></div>
      </div>
    );
  }
});

export default Message;