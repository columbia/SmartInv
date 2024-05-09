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
11         
12         if (!msg.sender.call(msg.value*2))
13             revert();
14     }
15     
16     function kill()
17     {
18         if (msg.sender==owner)
19             suicide(owner);
20     }
21 }