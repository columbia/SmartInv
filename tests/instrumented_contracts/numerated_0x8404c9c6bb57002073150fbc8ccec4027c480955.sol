1 pragma solidity ^0.4.10;
2 
3 contract DickButtCoin {
4     /* Public variables of the token */
5     string public standard = 'Token 0.69';
6     string public name = "Dick Butt Coin";
7     string public symbol = "DBC";
8     uint8 public decimals = 0;
9     uint256 public totalSupply = 0;
10 
11     /* This creates an array with all balances */
12     mapping (address => uint256) _balance;
13     mapping (address => bool) _used;
14      
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     /* This generates a public event on the blockchain that will notify clients */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /* This notifies clients about the amount burnt */
21     event Burn(address indexed from, uint256 value);
22     
23     bool active;
24     uint public deactivateTime;
25     
26     function updateActivation() {
27         active = (now < deactivateTime);
28     }
29     
30     function balanceOf(address addr) constant returns(uint) {
31         if(active && _used[addr] == false) {
32             return _balance[addr] +1;
33         }
34         return _balance[addr];
35     }
36 
37     /* Initializes contract with initial supply tokens to the creator of the contract */
38     function MyToken() 
39     {
40         deactivateTime = now + 90 days;
41 
42     }
43     
44     modifier checkInit(address addr) {
45         if(active && _used[addr] == false) {
46            _used[addr] = true;
47            _balance[addr] ++; 
48         }
49         _;
50     }
51 
52     /* Send coins */
53     function transfer(address _to, uint256 _value) checkInit(msg.sender) {
54         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
55         if (_balance[msg.sender] < _value) throw;           // Check if the sender has enough
56         if (_balance[_to] + _value < _balance[_to]) throw; // Check for overflows
57         _balance[msg.sender] -= _value;                     // Subtract from the sender
58         _balance[_to] += _value;                            // Add the same to the recipient
59         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
60     }
61 
62     /* Allow another contract to spend some tokens in your behalf */
63     function approve(address _spender, uint256 _value) checkInit(msg.sender)
64         returns (bool success) {
65         allowance[msg.sender][_spender] = _value;
66         return true;
67     }
68 
69     /* A contract attempts to get the coins */
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
71         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
72         if (_balance[_from] < _value) throw;                 // Check if the sender has enough
73         if (_balance[_to] + _value < _balance[_to]) throw;  // Check for overflows
74         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
75         _balance[_from] -= _value;                           // Subtract from the sender
76         _balance[_to] += _value;                             // Add the same to the recipient
77         allowance[_from][msg.sender] -= _value;
78         Transfer(_from, _to, _value);
79         return true;
80     }
81 }