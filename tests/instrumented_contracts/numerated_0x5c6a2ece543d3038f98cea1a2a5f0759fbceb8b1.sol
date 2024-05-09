1 pragma solidity ^0.4.24;
2 
3 /*
4     ERC20 Standard Token interface
5 */
6 contract IERC20Token {
7     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
8     function name() public constant returns (string) {}
9     function symbol() public constant returns (string) {}
10     function decimals() public constant returns (uint8) {}
11     function totalSupply() public constant returns (uint256) {}
12     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
13     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
14 
15     function transfer(address _to, uint256 _value) public returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17     function approve(address _spender, uint256 _value) public returns (bool success);
18 }
19 
20 /*
21     @title Provides support and utilities for contract ownership
22 */
23 contract Ownable {
24     address public owner;
25     address public newOwner;
26 
27     event OwnerUpdate(address _prevOwner, address _newOwner);
28 
29     /*
30         @dev constructor
31     */
32     constructor(address _owner) public {
33         owner = _owner;
34     }
35 
36     /*
37         @dev allows execution by the owner only
38     */
39     modifier ownerOnly {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     /*
45         @dev allows transferring the contract ownership
46         the new owner still needs to accept the transfer
47         can only be called by the contract owner
48 
49         @param _newOwner    new contract owner
50     */
51     function transferOwnership(address _newOwner) public ownerOnly {
52         require(_newOwner != owner);
53         newOwner = _newOwner;
54     }
55 
56     /*
57         @dev used by a new owner to accept an ownership transfer
58     */
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         emit OwnerUpdate(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 contract BatchTokensTransfer is Ownable {
68 
69     /*
70         @dev constructor
71 
72     */
73     constructor () public Ownable(msg.sender) {}
74 
75     function batchTokensTransfer(IERC20Token _token, address[] _usersWithdrawalAccounts, uint256[] _amounts) 
76         public
77         ownerOnly()
78         {
79             require(_usersWithdrawalAccounts.length == _amounts.length);
80 
81             for (uint i = 0; i < _usersWithdrawalAccounts.length; i++) {
82                 if (_usersWithdrawalAccounts[i] != 0x0) {
83                     _token.transfer(_usersWithdrawalAccounts[i], _amounts[i]);
84                 }
85             }
86         }
87 
88     function transferToken(IERC20Token _token, address _userWithdrawalAccount, uint256 _amount)
89         public
90         ownerOnly()
91         {
92             require(_userWithdrawalAccount != 0x0 && _amount > 0);
93             _token.transfer(_userWithdrawalAccount, _amount);
94         }
95 
96     function transferAllTokensToOwner(IERC20Token _token)
97         public
98         ownerOnly()
99         {
100             uint256 _amount = _token.balanceOf(this);
101             _token.transfer(owner, _amount);
102         }
103 }