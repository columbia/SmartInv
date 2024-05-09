1 contract Doubler
2 {
3     address owner;
4 
5     function Doubler() payable
6     {
7         owner = msg.sender;
8     }
9     
10     function() payable{
11         if (msg.value<0.2 ether)
12             revert();
13         if (!msg.sender.call(msg.value*2))
14             revert();
15     }
16     
17     function kill()
18     {
19         if (msg.sender==owner)
20             suicide(owner);
21     }
22 }