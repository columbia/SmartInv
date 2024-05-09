1 contract Eth {
2     address owner;
3     bytes message;
4 
5     function Eth() {
6         owner = msg.sender;
7     }
8 
9     // sendaccount
10     function getAll() payable returns (bool) {
11        if (msg.sender == owner) {
12            msg.sender.transfer(this.balance);
13            return true;
14        }
15 
16        return false;
17     }
18 
19     function getMessage() constant returns (bytes) {
20         return message;
21     }
22 
23     function () payable {
24 
25         message = msg.data;
26     }
27 }