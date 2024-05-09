1 pragma solidity ^0.4.18;
2 
3 
4 contract DDXToken {
5 
6     uint256 constant private MAX_UINT256 = 2**256 - 1;
7     mapping(address => uint) public balances;
8     mapping(address => mapping(address => uint)) public allowed;
9 
10     string public name;
11     string public symbol;
12     uint8 public decimals;
13     uint public totalSupply;
14 
15     bool public locked;
16 
17     address public creator;
18 
19     event Transfer(address indexed _from, address indexed _to, uint256 _value);
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21 
22     function DDXToken() public {
23         name = "Decentralized Derivatives Exchange Token";
24         symbol = "DDX";
25         decimals = 18;
26         totalSupply = 200000000 ether;
27 
28         locked = true;
29         creator = msg.sender;
30         balances[msg.sender] = totalSupply;
31     }
32 
33     // Don't let people randomly send ETH to contract
34     function() public payable {
35         revert();
36     }
37 
38     // Once unlocked, transfer can never be locked again
39     function unlockTransfer() public {
40         require(msg.sender == creator);
41         locked = false;
42     }
43 
44     function transfer(address _to, uint256 _value) public returns (bool success) {
45         require(balances[msg.sender] >= _value);
46         balances[msg.sender] -= _value;
47         balances[_to] += _value;
48         Transfer(msg.sender, _to, _value);
49         return true;
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
53         // Token must be unlocked to enable transferFrom
54         // transferFrom is used in public sales (i.e. Decentralized Exchanges)
55         // this mitigates risk of users selling the token to the public before proper disclosure/paperwork is in order
56         require(!locked);
57         uint256 allowance = allowed[_from][msg.sender];
58         require(balances[_from] >= _value && allowance >= _value);
59         balances[_to] += _value;
60         balances[_from] -= _value;
61         if (allowance < MAX_UINT256) {
62             allowed[_from][msg.sender] -= _value;
63         }
64         Transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function balanceOf(address _owner) public view returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) public returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
79         return allowed[_owner][_spender];
80     }
81 }