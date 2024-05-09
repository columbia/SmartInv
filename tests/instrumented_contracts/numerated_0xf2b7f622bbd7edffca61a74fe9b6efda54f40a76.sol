1 pragma solidity ^0.4.4;
2 
3 /**
4  * @title Contract for object that have an owner
5  */
6 contract Owned {
7     /**
8      * Contract owner address
9      */
10     address public owner;
11 
12     /**
13      * @dev Delegate contract to another person
14      * @param _owner New owner address 
15      */
16     function setOwner(address _owner) onlyOwner
17     { owner = _owner; }
18 
19     /**
20      * @dev Owner check modifier
21      */
22     modifier onlyOwner { if (msg.sender != owner) throw; _; }
23 }
24 
25 /**
26  * @title Common pattern for destroyable contracts 
27  */
28 contract Destroyable {
29     address public hammer;
30 
31     /**
32      * @dev Hammer setter
33      * @param _hammer New hammer address
34      */
35     function setHammer(address _hammer) onlyHammer
36     { hammer = _hammer; }
37 
38     /**
39      * @dev Destroy contract and scrub a data
40      * @notice Only hammer can call it 
41      */
42     function destroy() onlyHammer
43     { suicide(msg.sender); }
44 
45     /**
46      * @dev Hammer check modifier
47      */
48     modifier onlyHammer { if (msg.sender != hammer) throw; _; }
49 }
50 
51 /**
52  * @title Generic owned destroyable contract
53  */
54 contract Object is Owned, Destroyable {
55     function Object() {
56         owner  = msg.sender;
57         hammer = msg.sender;
58     }
59 }
60 
61 // Standard token interface (ERC 20)
62 // https://github.com/ethereum/EIPs/issues/20
63 contract ERC20 
64 {
65 // Functions:
66     /// @return total amount of tokens
67     uint256 public totalSupply;
68 
69     /// @param _owner The address from which the balance will be retrieved
70     /// @return The balance
71     function balanceOf(address _owner) constant returns (uint256);
72 
73     /// @notice send `_value` token to `_to` from `msg.sender`
74     /// @param _to The address of the recipient
75     /// @param _value The amount of token to be transferred
76     /// @return Whether the transfer was successful or not
77     function transfer(address _to, uint256 _value) returns (bool);
78 
79     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
80     /// @param _from The address of the sender
81     /// @param _to The address of the recipient
82     /// @param _value The amount of token to be transferred
83     /// @return Whether the transfer was successful or not
84     function transferFrom(address _from, address _to, uint256 _value) returns (bool);
85 
86     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
87     /// @param _spender The address of the account able to transfer the tokens
88     /// @param _value The amount of wei to be approved for transfer
89     /// @return Whether the approval was successful or not
90     function approve(address _spender, uint256 _value) returns (bool);
91 
92     /// @param _owner The address of the account owning tokens
93     /// @param _spender The address of the account able to transfer the tokens
94     /// @return Amount of remaining tokens allowed to spent
95     function allowance(address _owner, address _spender) constant returns (uint256);
96 
97 // Events:
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 }
101 
102 contract Presale is Object {
103     ERC20   public token;
104     uint256 public bounty;
105     uint256 public donation;
106 
107     /**
108      * @dev Presale contract constructor
109      * @param _token Bounty token address
110      * @param _bounty Bount value by donation
111      * @param _donation Donation value
112      */
113     function Presale(address _token, uint256 _bounty, uint256 _donation) {
114         token    = ERC20(_token);
115         bounty   = _bounty;
116         donation = _donation;
117     }
118 
119     /**
120      * @dev Cancel presale contract by owner, bounty refunded to owner
121      */
122     function cancel() onlyOwner {
123         if (!token.transfer(owner, bounty)) throw;
124     }
125 
126     /**
127     * @dev Accept presale contract,
128     *      bounty transfered to sender - donation to owner
129     */
130     function () payable {
131         if (msg.value != donation) throw;
132         if (!token.transfer(msg.sender, bounty)) throw;
133         if (!owner.send(msg.value)) throw;
134     }
135 }