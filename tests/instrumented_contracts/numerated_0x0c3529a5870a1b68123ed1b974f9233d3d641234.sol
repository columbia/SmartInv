1 pragma solidity ^0.4.23;
2 
3 contract CSC {
4     mapping (address => uint256) private balances;
5     mapping (address => uint256[2]) private lockedBalances;
6     string public name;                   //fancy name: eg Simon Bucks
7     uint8 public decimals;                //How many decimals to show.
8     string public symbol;                 //An identifier: eg SBX
9     uint256 public totalSupply;
10     address public owner;
11         event Transfer(address indexed _from, address indexed _to, uint256 _value); 
12     constructor(
13         uint256 _initialAmount,
14         string _tokenName,
15         uint8 _decimalUnits,
16         string _tokenSymbol,
17         address _owner,
18         address[] _lockedAddress,
19         uint256[] _lockedBalances,
20         uint256[] _lockedTimes
21     ) public {
22         balances[_owner] = _initialAmount;                   // Give the owner all initial tokens
23         totalSupply = _initialAmount;                        // Update total supply
24         name = _tokenName;                                   // Set the name for display purposes
25         decimals = _decimalUnits;                            // Amount of decimals for display purposes
26         symbol = _tokenSymbol;                               // Set the symbol for display purposes
27         owner = _owner;                                      // set owner
28         for(uint i = 0;i < _lockedAddress.length;i++){
29             lockedBalances[_lockedAddress[i]][0] = _lockedBalances[i];
30             lockedBalances[_lockedAddress[i]][1] = _lockedTimes[i];
31         }
32     }
33     function transfer(address _to, uint256 _value) public returns (bool success) {
34         
35         if(_to != address(0)){
36             if(lockedBalances[msg.sender][1] >= now) {
37                 require((balances[msg.sender] > lockedBalances[msg.sender][0]) &&
38                  (balances[msg.sender] - lockedBalances[msg.sender][0] >= _value));
39             } else {
40                 require(balances[msg.sender] >= _value);
41             }
42             balances[msg.sender] -= _value;
43             balances[_to] += _value;
44             emit Transfer(msg.sender, _to, _value);
45             return true;
46         }
47     }
48     function burnFrom(address _who,uint256 _value)public returns (bool){
49         require(msg.sender == owner);
50         assert(balances[_who] >= _value);
51         totalSupply -= _value;
52         balances[_who] -= _value;
53         lockedBalances[_who][0] = 0;
54         lockedBalances[_who][1] = 0;
55         return true;
56     }
57     function makeCoin(uint256 _value)public returns (bool){
58         require(msg.sender == owner);
59         totalSupply += _value;
60         balances[owner] += _value;
61         return true;
62     }
63     function balanceOf(address _owner) public view returns (uint256 balance) {
64         return balances[_owner];
65     }
66     function withdraw() public{
67         require(msg.sender == owner);
68         msg.sender.transfer(address(this).balance);
69     }
70     function withdrawTo(address _to) public{
71         require(msg.sender == owner);
72         address(_to).transfer(address(this).balance);
73     }
74 }