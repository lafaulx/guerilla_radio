import axios from 'axios';

const MessageAPI = {
  getAll: function(broadcast) {
    return axios
    .get('/api/messages', {
      params: {
        broadcast: broadcast
      }
    })
    .then(function(response) {
      return response.data;
    })
    .catch(function() {
      return [];
    });
  }
};

export default MessageAPI;