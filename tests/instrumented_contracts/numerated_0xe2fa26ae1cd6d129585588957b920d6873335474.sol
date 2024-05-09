1 contract echo {
2   /* Constructor */
3   function () {
4     msg.sender.send(msg.value);
5   }
6 }