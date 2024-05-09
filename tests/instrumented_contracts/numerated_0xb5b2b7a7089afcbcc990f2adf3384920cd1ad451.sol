1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14     
15     function withdraw() public onlyOwner{
16         owner.transfer(address(this).balance);
17     }
18 
19 }
20 
21 
22 contract MagicBox is Ownable {
23     uint256 public cancelFee = 10 finney;
24 
25     function setCancelFee(uint256 _fee) public onlyOwner{
26         cancelFee = _fee;
27     }
28     
29     function transfer(address _to,uint256 _amount) public payable{
30         require(_to != address(0));
31         require(msg.value>=_amount);
32         _to.transfer(_amount);
33     }
34     
35     function cancelTx() public payable{
36         require(msg.value>=cancelFee);
37     }
38     
39     function plain() public payable{
40     }
41     
42     function() public payable{
43     }
44 
45 }