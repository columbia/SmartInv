1 pragma solidity ^0.4.23;
2 
3 contract RVC {
4     mapping (address => uint256) private balances;
5     string public name;
6     uint8 public decimals;
7     string public symbol;
8     uint256 public totalSupply;
9     address public owner;
10     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
11     constructor(
12         uint256 _initialAmount,
13         string _tokenName,
14         uint8 _decimalUnits,
15         string _tokenSymbol,
16         address _owner
17     ) public {
18         balances[_owner] = _initialAmount;
19         totalSupply = _initialAmount;
20         name = _tokenName;
21         decimals = _decimalUnits;
22         symbol = _tokenSymbol;
23         owner = _owner;
24     }
25     function transfer(address _to, uint256 _value) public returns (bool success) {
26         if(_to != address(0)){
27             require(balances[msg.sender] >= _value);
28             balances[msg.sender] -= _value;
29             balances[_to] += _value;
30             emit Transfer(msg.sender, _to, _value);
31             return true;
32         }
33     }
34     function burnFrom(address _who,uint256 _value)public returns (bool){
35         require(msg.sender == owner);
36         assert(balances[_who] >= _value);
37         totalSupply -= _value;
38         balances[_who] -= _value;
39         return true;
40     }
41     function balanceOf(address _owner) public view returns (uint256 balance) {
42         return balances[_owner];
43     }
44 }