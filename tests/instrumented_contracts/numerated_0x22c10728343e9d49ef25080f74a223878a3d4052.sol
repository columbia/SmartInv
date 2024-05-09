1 pragma solidity ^0.4.8;
2 
3 contract DigitalRupiah {
4     /* Public variables of the token */
5     string public standard = 'ERC20';
6     string public name =  'Digital Rupiah';
7     string public symbol = 'DRP' ;
8     uint8 public decimals = 8 ;
9     uint256 public totalSupply = 10000000000000000;
10 
11     /* This creates an array with all balances */
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     /* This generates a public event on the blockchain that will notify clients */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18 
19     /* Send coins */
20     function transfer(address _to, uint256 _value) {
21         balanceOf[_to] += _value;                            // Add the same to the recipient
22         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
23     }
24 
25     /* Allow another contract to spend some tokens in your behalf */
26     function approve(address _spender, uint256 _value)
27         returns (bool success) {
28         allowance[msg.sender][_spender] = _value;
29         return true;
30     }
31        
32 
33     /* A contract attempts to get the coins */
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
35         balanceOf[_from] -= _value;                           // Subtract from the sender
36         balanceOf[_to] += _value;                             // Add the same to the recipient
37         allowance[_from][msg.sender] -= _value;
38         Transfer(_from, _to, _value);
39         return true;
40     }
41 }