1 pragma solidity 0.5.11;
2 
3 contract IToken {
4     function balanceOf(address) public view returns (uint256);
5     function transfer(address to, uint value) public;
6 }
7 
8 contract Manageable {
9     mapping(address => bool) public admins;
10     constructor() public {
11         admins[msg.sender] = true;
12     }
13 
14     modifier onlyAdmins() {
15         require(admins[msg.sender]);
16         _;
17     }
18 
19     function modifyAdmins(address[] memory newAdmins, address[] memory removedAdmins) public onlyAdmins {
20         for(uint256 index; index < newAdmins.length; index++) {
21             admins[newAdmins[index]] = true;
22         }
23         for(uint256 index; index < removedAdmins.length; index++) {
24             admins[removedAdmins[index]] = false;
25         }
26     }
27 }
28 
29 contract HotWallet is Manageable {
30     mapping(uint256 => bool) public isPaid;
31     event Transfer(uint256 transactionRequestId, address coinAddress, uint256 value, address payable to);
32     
33     function transfer(uint256 transactionRequestId, address coinAddress, uint256 value, address payable to) public onlyAdmins {
34         require(!isPaid[transactionRequestId]);
35         isPaid[transactionRequestId] = true;
36         emit Transfer(transactionRequestId, coinAddress, value, to);
37         if (coinAddress == address(0)) {
38             return to.transfer(value);
39         }
40         IToken(coinAddress).transfer(to, value);
41     }
42     
43     function getBalances(address coinAddress) public view returns (uint256 balance)  {
44         if (coinAddress == address(0)) {
45             return address(this).balance;
46         }
47         return IToken(coinAddress).balanceOf(address(this));
48     }
49 
50     function () external payable {}
51 }