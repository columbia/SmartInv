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
33     /*DirectDrop and AirDrop*/
34     /*Checking lock limit and time limit while transfering.*/
35     function transfer(address _to, uint256 _value) public returns (bool success) {
36         //Before ICO finish, only own could transfer.
37         if(_to != address(0)){
38             if(lockedBalances[msg.sender][1] >= now) {
39                 require((balances[msg.sender] > lockedBalances[msg.sender][0]) &&
40                  (balances[msg.sender] - lockedBalances[msg.sender][0] >= _value));
41             } else {
42                 require(balances[msg.sender] >= _value);
43             }
44             balances[msg.sender] -= _value;
45             balances[_to] += _value;
46             emit Transfer(msg.sender, _to, _value);
47             return true;
48         }
49     }
50     /*With permission, destory token from an address and minus total amount.*/
51     function burnFrom(address _who,uint256 _value)public returns (bool){
52         require(msg.sender == owner);
53         assert(balances[_who] >= _value);
54         totalSupply -= _value;
55         balances[_who] -= _value;
56         lockedBalances[_who][0] = 0;
57         lockedBalances[_who][1] = 0;
58         return true;
59     }
60     /*With permission, creating coin.*/
61     function makeCoin(uint256 _value)public returns (bool){
62         require(msg.sender == owner);
63         totalSupply += _value;
64         balances[owner] += _value;
65         return true;
66     }
67     function balanceOf(address _owner) public view returns (uint256 balance) {
68         return balances[_owner];
69     }
70     /*With permission, withdraw ETH to owner address from smart contract.*/
71     function withdraw() public{
72         require(msg.sender == owner);
73         msg.sender.transfer(address(this).balance);
74     }
75     /*With permission, withdraw ETH to an address from smart contract.*/
76     function withdrawTo(address _to) public{
77         require(msg.sender == owner);
78         address(_to).transfer(address(this).balance);
79     }
80 }