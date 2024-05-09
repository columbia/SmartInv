1 pragma solidity ^0.4.11;
2 
3 contract Listen{
4     address public owner;
5     
6     event Transfer(address from ,address  to ,uint value );
7     
8     modifier onlyOwner{
9         if(msg.sender != owner) throw;
10         _;
11     }
12     
13     function Listen(){
14         owner =  msg.sender;
15     }
16     
17     function changeOwner(address _owner){
18         owner = _owner;
19     }
20     
21     function() payable{
22         Transfer(msg.sender,this,msg.value);
23     }
24     
25     function draw() onlyOwner{
26         if(this.balance > 0){
27              owner.transfer(this.balance);
28         }
29     }
30     
31     function destroy() onlyOwner{
32         suicide(owner);
33     }
34     
35 }