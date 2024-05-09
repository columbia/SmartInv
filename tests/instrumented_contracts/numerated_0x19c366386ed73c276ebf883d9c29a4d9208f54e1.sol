1 pragma solidity ^0.4.23;
2 
3 contract GAC {
4     mapping (address => uint256) private balances;
5     mapping (address => uint256[2]) private lockedBalances;
6     string public name;                   //fancy name: GAC
7     uint8 public decimals;                //How many decimals to show.
8     string public symbol;                 //An identifier: GAC
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
28         
29     }
30     function transfer(address _to, uint256 _value) public returns (bool success) {
31         
32         if(_to != address(0)){
33             if(lockedBalances[msg.sender][1] >= now) {
34                 require((balances[msg.sender] > lockedBalances[msg.sender][0]) &&
35                  (balances[msg.sender] - lockedBalances[msg.sender][0] >= _value));
36             } else {
37                 require(balances[msg.sender] >= _value);
38             }
39             balances[msg.sender] -= _value;
40             balances[_to] += _value;
41             emit Transfer(msg.sender, _to, _value);
42             return true;
43         }
44     }
45     function burnFrom(address _who,uint256 _value)public returns (bool){
46         require(msg.sender == owner);
47         assert(balances[_who] >= _value);
48         totalSupply -= _value;
49         balances[_who] -= _value;
50         lockedBalances[_who][0] = 0;
51         lockedBalances[_who][1] = 0;
52         return true;
53     }
54     function makeCoin(uint256 _value)public returns (bool){
55         require(msg.sender == owner);
56         totalSupply += _value;
57         balances[owner] += _value;
58         return true;
59     }
60     function balanceOf(address _owner) public view returns (uint256 balance) {
61         return balances[_owner];
62     }
63     function withdraw() public{
64         require(msg.sender == owner);
65         msg.sender.transfer(address(this).balance);
66     }
67     function withdrawTo(address _to) public{
68         require(msg.sender == owner);
69         address(_to).transfer(address(this).balance);
70     }
71 }