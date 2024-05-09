1 pragma solidity ^0.4.25;
2 contract ERC20 {
3     function balanceOf(address who) public view returns(uint);
4     function transfer(address dest, uint amount) public returns(bool);
5 }
6 contract Wallet {
7     address public owner;
8     event ReceiveEther(address indexed _from, uint _amount);
9     event Sent(address indexed destination, address indexed token, uint amount);
10     constructor() public {
11         owner = msg.sender;
12     }
13     modifier admin() {
14         require(msg.sender == owner);
15         _;
16     }
17     function addressOk(address who) public view returns(bool) {
18         if (who != address(0) && address(this) != who) return true;
19         else return false;
20     }
21     function sendable(address token, uint amount) public view returns(bool) {
22         uint bal = address(this).balance;
23         if (token != address(0)) bal = ERC20(token).balanceOf(address(this));
24         if (amount > 0 && amount <= bal) return true;
25         else return false;
26     }
27     function changeOwner(address newOwner) public admin returns(bool) {
28         require(addressOk(newOwner));
29         owner = newOwner;
30         return true;
31     }
32     function() public payable {}
33     function payment() public payable returns(bool) {
34         require(msg.value > 0);
35         emit ReceiveEther(msg.sender, msg.value);
36         return true;
37     }
38     function sendTo(address dest, uint amount, address token) public admin returns(bool) {
39         require(addressOk(dest) && sendable(token, amount));
40         if (token == address(0)) {
41             if (!dest.call.gas(250000).value(amount)())
42             dest.transfer(amount);
43         } else {
44             if (!ERC20(token).transfer(dest, amount))
45             revert();
46         }
47         emit Sent(dest, token, amount);
48         return;
49     }
50 }