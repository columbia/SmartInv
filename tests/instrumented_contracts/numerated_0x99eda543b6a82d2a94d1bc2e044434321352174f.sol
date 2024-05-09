1 pragma solidity ^0.4.11;
2 
3 contract MeetupToken {
4     
5     uint256 public totalSupply;
6     mapping (address => uint256) balances;
7     
8     string public name;               
9     uint8 public decimals;                
10     string public symbol;
11    
12     function MeetupToken(
13         uint256 _initialAmount,
14         string _tokenName,
15         uint8 _decimalUnits,
16         string _tokenSymbol
17         ) {
18         balances[msg.sender] = _initialAmount;      
19         totalSupply = _initialAmount;                        
20         name = _tokenName;                                   
21         decimals = _decimalUnits;                            
22         symbol = _tokenSymbol;                               
23     }
24     
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         if (balances[msg.sender] >= _value) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function balanceOf(address _owner) constant returns (uint256 balance) {
35         return balances[_owner];
36     }
37     
38     function () {
39         throw;
40     }
41     
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43 }