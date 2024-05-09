1 pragma solidity ^0.4.8;
2 contract Soarcoin {
3 
4     mapping (address => uint256) balances;               // each address in this contract may have tokens. 
5     address internal owner = 0x4Bce8E9850254A86a1988E2dA79e41Bc6793640d;                // the owner is the creator of the smart contract
6     string public name = "Soarcoin";                     // name of this contract and investment fund
7     string public symbol = "SOAR";                       // token symbol
8     uint8 public decimals = 6;                           // decimals (for humans)
9     uint256 public totalSupply = 5000000000000000;  
10            
11     modifier onlyOwner()
12     {
13         if (msg.sender != owner) throw;
14         _;
15     }
16 
17     function Soarcoin() { balances[owner] = totalSupply; }    
18 
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     // query balance
23     function balanceOf(address _owner) constant returns (uint256 balance)
24     {
25         return balances[_owner];
26     }
27 
28     // transfer tokens from one address to another
29     function transfer(address _to, uint256 _value) returns (bool success)
30     {
31         if(_value <= 0) throw;                                      // Check send token value > 0;
32         if (balances[msg.sender] < _value) throw;                   // Check if the sender has enough
33         if (balances[_to] + _value < balances[_to]) throw;          // Check for overflows                          
34         balances[msg.sender] -= _value;                             // Subtract from the sender
35         balances[_to] += _value;                                    // Add the same to the recipient, if it's the contact itself then it signals a sell order of those tokens                       
36         Transfer(msg.sender, _to, _value);                          // Notify anyone listening that this transfer took place
37         return true;      
38     }
39 
40     function mint(address _to, uint256 _value) onlyOwner
41     {
42         if(_value <= 0) throw;
43     	balances[_to] += _value;
44     	totalSupply += _value;
45     }
46 }
47 
48 /**
49  * ERC 20 token
50  *
51  * https://github.com/ethereum/EIPs/issues/20
52  */
53 contract Token is Soarcoin {
54 
55     /// @return total amount of tokens
56     
57 
58     /// @param _owner The address from which the balance will be retrieved
59     /// @return The balance
60     function balanceOf(address _owner) constant returns (uint256 balance) {}
61 
62     /// @notice send `_value` token to `_to` from `msg.sender`
63     /// @param _to The address of the recipient
64     /// @param _value The amount of token to be transferred
65     /// @return Whether the transfer was successful or not
66     function transfer(address _to, uint256 _value) returns (bool success) {}
67 
68     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
69     /// @param _from The address of the sender
70     /// @param _to The address of the recipient
71     /// @param _value The amount of token to be transferred
72     /// @return Whether the transfer was successful or not
73     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
74 
75     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
76     /// @param _spender The address of the account able to transfer the tokens
77     /// @param _value The amount of wei to be approved for transfer
78     /// @return Whether the approval was successful or not
79     function approve(address _spender, uint256 _value) returns (bool success) {}
80 
81     /// @param _owner The address of the account owning tokens
82     /// @param _spender The address of the account able to transfer the tokens
83     /// @return Amount of remaining tokens allowed to spent
84     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
85 
86     
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88 
89 }
90 
91 /**
92  * ERC 20 token
93  *
94  * https://github.com/ethereum/EIPs/issues/20
95  */