1 contract BeerKeg {
2     bytes20 prev; // Nickname of the previous tap attempt
3 
4     function tap(bytes20 nickname) {
5         prev = nickname;
6         if (prev != nickname) {
7           msg.sender.send(this.balance);
8         }
9     }
10 }