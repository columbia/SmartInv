1 pragma solidity ^0.4.23;
2 
3 contract SPT {
4     mapping (address => uint256) private balances;
5     mapping (address => uint256[2]) private lockedBalances;
6     string public name;
7     uint8 public decimals;
8     string public symbol;
9     uint256 public totalSupply;
10     address public owner;
11     uint256 private icoLockUntil = 1553875200;
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     constructor(
14         uint256 _initialAmount,
15         string _tokenName,
16         uint8 _decimalUnits,
17         string _tokenSymbol,
18         address _owner,
19         address[] _lockedAddress,
20         uint256[] _lockedBalances,
21         uint256[] _lockedTimes
22     ) public {
23         balances[_owner] = _initialAmount;
24         totalSupply = _initialAmount;
25         name = _tokenName;
26         decimals = _decimalUnits;
27         symbol = _tokenSymbol;
28         owner = _owner;
29         for(uint i = 0;i < _lockedAddress.length;i++){
30             lockedBalances[_lockedAddress[i]][0] = _lockedBalances[i];
31             lockedBalances[_lockedAddress[i]][1] = _lockedTimes[i];
32         }
33     }
34     function transfer(address _to, uint256 _value) public returns (bool success) {
35         require(msg.sender == owner || icoLockUntil < now);
36         if(_to != address(0)){
37             if(lockedBalances[msg.sender][1] >= now) {
38                 require((balances[msg.sender] > lockedBalances[msg.sender][0]) &&
39                  (balances[msg.sender] - lockedBalances[msg.sender][0] >= _value));
40             } else {
41                 require(balances[msg.sender] >= _value);
42             }
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             emit Transfer(msg.sender, _to, _value);
46             return true;
47         }
48     }
49     function burnFrom(address _who,uint256 _value)public returns (bool){
50         require(msg.sender == owner);
51         assert(balances[_who] >= _value);
52         totalSupply -= _value;
53         balances[_who] -= _value;
54         lockedBalances[_who][0] = 0;
55         lockedBalances[_who][1] = 0;
56         return true;
57     }
58     function lockBalance(address _who,uint256 _value,uint256 _until) public returns (bool){
59         require(msg.sender == owner);
60         lockedBalances[_who][0] = _value;
61         lockedBalances[_who][1] = _until;
62         return true;
63     }
64     function lockedBalanceOf(address _owner)public view returns (uint256){
65         if(lockedBalances[_owner][1] >= now) {
66             return lockedBalances[_owner][0];
67         } else {
68             return 0;
69         }
70     }
71     function setIcoLockUntil(uint256 _until) public{
72         require(msg.sender == owner);
73         icoLockUntil = _until;
74     }
75     function balanceOf(address _owner) public view returns (uint256 balance) {
76         return balances[_owner];
77     }
78     function withdraw() public{
79         require(msg.sender == owner);
80         msg.sender.transfer(address(this).balance);
81     }
82 }