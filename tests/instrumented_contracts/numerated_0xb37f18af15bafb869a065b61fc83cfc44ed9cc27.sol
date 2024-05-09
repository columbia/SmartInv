1 pragma solidity ^0.4.24;
2 
3 
4 contract SimpleWallet {
5     address public owner = msg.sender;
6     uint public depositsCount;
7     
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     
13     function() public payable {
14         depositsCount++;
15     }
16     
17     function withdrawAll() public onlyOwner {
18         withdraw(address(this).balance);
19     }
20     
21     function withdraw(uint _value) public onlyOwner {
22         msg.sender.transfer(_value);
23     }
24     
25     function sendMoney(address _target, uint _value) public onlyOwner {
26         _target.call.value(_value)();
27     }
28 }