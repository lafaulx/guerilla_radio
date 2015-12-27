import React from 'react';
import ReactDOM from 'react-dom';

import App from './components/App';

ReactDOM.render(<App broadcast={window.state.broadcast} messages={window.state.messages} />, document.getElementById('app'));