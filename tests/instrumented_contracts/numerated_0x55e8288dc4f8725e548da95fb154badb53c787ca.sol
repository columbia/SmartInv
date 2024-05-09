1 pragma solidity ^0.4.20;
2 
3 contract Envelop {
4     /// @dev `owner` is the only address that can call a function with this
5     /// modifier
6     modifier onlyOwner() {
7         require(msg.sender == owner) ;
8         _;
9     }
10     
11     address public owner;
12 
13     /// @notice The Constructor assigns the message sender to be `owner`
14     function Envelop() public {
15         owner = msg.sender;
16     }
17     
18     mapping(address => uint) public accounts;
19     bytes32 public hashKey;
20      
21     function start(string _key) public onlyOwner{
22         hashKey = sha3(_key);
23     }
24     
25     function bid(string _key) public {
26         if (sha3(_key) == hashKey && accounts[msg.sender] != 1) {
27             accounts[msg.sender] = 1;
28             msg.sender.transfer(1e16);
29         }
30     }
31     
32     function () payable {
33     }
34 }