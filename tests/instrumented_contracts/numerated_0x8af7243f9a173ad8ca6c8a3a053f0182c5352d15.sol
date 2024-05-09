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
42     	balances[_to] += _value;
43     	totalSupply += _value;
44     }
45 }