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
11         uint256 private icoLockUntil = 1543593540;
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
23         balances[_owner] = _initialAmount;                   // Give the owner all initial tokens
24         totalSupply = _initialAmount;                        // Update total supply
25         name = _tokenName;                                   // Set the name for display purposes
26         decimals = _decimalUnits;                            // Amount of decimals for display purposes
27         symbol = _tokenSymbol;                               // Set the symbol for display purposes
28         owner = _owner;                                      // set owner
29         for(uint i = 0;i < _lockedAddress.length;i++){
30             lockedBalances[_lockedAddress[i]][0] = _lockedBalances[i];
31             lockedBalances[_lockedAddress[i]][1] = _lockedTimes[i];
32         }
33     }
34     /*外部直投和空投
35      */
36     /*转账 会检测是否有锁仓限额和期限
37      */
38     function transfer(address _to, uint256 _value) public returns (bool success) {
39         //当ICO未完成时，除owner外禁止转账
40         require(msg.sender == owner || icoLockUntil < now);
41         if(_to != address(0)){
42             if(lockedBalances[msg.sender][1] >= now) {
43                 require((balances[msg.sender] > lockedBalances[msg.sender][0]) &&
44                  (balances[msg.sender] - lockedBalances[msg.sender][0] >= _value));
45             } else {
46                 require(balances[msg.sender] >= _value);
47             }
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             emit Transfer(msg.sender, _to, _value);
51             return true;
52         }
53     }
54     /*从某地址摧毁某数量的代币并减少总供应量 需要拥有者权限
55      */
56     function burnFrom(address _who,uint256 _value)public returns (bool){
57         require(msg.sender == owner);
58         assert(balances[_who] >= _value);
59         totalSupply -= _value;
60         balances[_who] -= _value;
61         lockedBalances[_who][0] = 0;
62         lockedBalances[_who][1] = 0;
63         return true;
64     }
65     /*铸币到创始者账户并增加总供应量 需要拥有者权限
66      */
67     function makeCoin(uint256 _value)public returns (bool){
68         require(msg.sender == owner);
69         totalSupply += _value;
70         balances[owner] += _value;
71         return true;
72     }
73     /*设置ICO锁仓到期时间，需要拥有管理者权限
74      */
75     function setIcoLockUntil(uint256 _until) public{
76         require(msg.sender == owner);
77         icoLockUntil = _until;
78     }
79     function balanceOf(address _owner) public view returns (uint256 balance) {
80         return balances[_owner];
81     }
82     /*将合约中的ETH提取到创始者地址中 需求拥有者权限
83      */
84     function withdraw() public{
85         require(msg.sender == owner);
86         msg.sender.transfer(address(this).balance);
87     }
88     /*将合约中的ETH提取到某个地址中 需求拥有者权限
89      */
90     function withdrawTo(address _to) public{
91         require(msg.sender == owner);
92         address(_to).transfer(address(this).balance);
93     }
94 }