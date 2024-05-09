1 pragma solidity ^0.4.17;
2 
3 contract TheDapp {
4 
5   string public message;
6   address public owner;
7   uint256 public fee;
8 
9   event OnUpdateMessage();
10   event OnUpdateFee();
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function TheDapp(uint256 _fee) public {
18     owner = msg.sender;
19     fee = (_fee * 1 finney);
20   }
21 
22   function setMessage(string _message) public payable {
23     require(msg.value == fee);
24     message = _message;
25     OnUpdateMessage();
26   }
27   
28   function setFee(uint256 _fee) public onlyOwner {
29     fee = (_fee * 1 finney);
30     OnUpdateFee();
31   }
32 
33   function withdraw(address addr) public onlyOwner {
34     addr.transfer(this.balance);
35   }
36 
37   function kill() public onlyOwner {
38     selfdestruct(owner);
39   }
40 }