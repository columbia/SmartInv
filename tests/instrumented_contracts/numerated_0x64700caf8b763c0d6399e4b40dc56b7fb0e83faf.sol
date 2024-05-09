1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // Owned contract
5 // ----------------------------------------------------------------------------
6 contract Owned {
7     address public owner;
8 
9     event OwnershipTransferred(address indexed _from, address indexed _to);
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16 }
17 
18 contract FundsTransfer is Owned{
19     address public wallet;
20     // ------------------------------------------------------------------------
21     // Constructor
22     // ------------------------------------------------------------------------
23     constructor (address _wallet, address _owner) public{
24         wallet = _wallet;
25         owner = _owner;
26     }
27 
28     function () external payable{
29         _forwardFunds(msg.value);   
30     }
31   
32     function _forwardFunds(uint256 _amount) internal {
33         wallet.transfer(_amount);
34     }
35     
36     function changeWallet(address newWallet) public onlyOwner {
37         wallet = newWallet;
38     }
39 }