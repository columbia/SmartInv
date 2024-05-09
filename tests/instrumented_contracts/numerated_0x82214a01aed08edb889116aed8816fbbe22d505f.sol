1 pragma solidity ^0.4.0;
2 
3 contract StandardToken  {
4 
5     function transfer(address _to, uint256 _value) returns (bool success);
6 
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8 
9     function balanceOf(address _owner) constant returns (uint256 balance);
10 
11     function approve(address _spender, uint256 _value) returns (bool success);
12 
13     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
14 
15 }
16 
17 contract usingTokenContract {
18 
19      StandardToken token;
20      mapping(bytes32 => bool) public administrators;
21      uint256 public stakingRequirement = 5e18;
22      uint256 public messagingRequirement = 5e18;
23      
24      modifier onlyAdministrator(){
25         address _customerAddress = msg.sender;
26         require(administrators[keccak256(_customerAddress)]);
27         _;
28     }
29      
30 
31      function usingTokenContract() {
32          token = StandardToken(0x07d9e49ea402194bf48a8276dafb16e4ed633317);
33          administrators[0x7f5be223ca67e25627c96e839775b3401c1ba4d617afc27a77a866e071ed401d] = true; 
34      }
35      
36      function setStakingRequirement(uint256 _amountOfTokens)
37         onlyAdministrator()
38         public
39     {
40         stakingRequirement = _amountOfTokens;
41     }
42 
43     function setMessagingRequirement(uint256 _amountOfTokens)
44         onlyAdministrator()
45         public
46     {
47         messagingRequirement = _amountOfTokens;
48     }
49      
50   
51     function userTokenBalance(address _userAddress) constant returns(uint256 balance) {
52          return token.balanceOf(_userAddress);
53      }
54      
55     
56     function validateUser(address _userAddress) public constant returns(bool) {
57         if(userTokenBalance(_userAddress)>=stakingRequirement) {
58             return true;
59         }else{
60             return false;
61         }
62     }
63 
64     function validateUserForMessaging(address _userAddress) public constant returns(bool) {
65         if(userTokenBalance(_userAddress)>=messagingRequirement) {
66             return true;
67         }else{
68             return false;
69         }
70     }
71 }