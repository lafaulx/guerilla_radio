import axios from 'axios';

const MessageAPI = {
  getPage: function(params) {
    return axios
    .get('/api/messages', {
      params: params
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