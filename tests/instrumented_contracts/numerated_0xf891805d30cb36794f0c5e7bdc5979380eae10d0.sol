1 pragma solidity ^0.4.23;
2 
3 contract PHC {
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
17         address _owner
18     ) public {
19         balances[_owner] = _initialAmount;                   // Give the owner all initial tokens
20         totalSupply = _initialAmount;                        // Update total supply
21         name = _tokenName;                                   // Set the name for display purposes
22         decimals = _decimalUnits;                            // Amount of decimals for display purposes
23         symbol = _tokenSymbol;                               // Set the symbol for display purposes
24         owner = _owner;                                      // set owner
25         
26     }
27     /*DirectDrop and AirDrop*/
28     /*Checking lock limit and time limit while transfering.*/
29     function transfer(address _to, uint256 _value) public returns (bool success) {
30         //Before ICO finish, only own could transfer.
31         if(_to != address(0)){
32             if(lockedBalances[msg.sender][1] >= now) {
33                 require((balances[msg.sender] > lockedBalances[msg.sender][0]) &&
34                  (balances[msg.sender] - lockedBalances[msg.sender][0] >= _value));
35             } else {
36                 require(balances[msg.sender] >= _value);
37             }
38             balances[msg.sender] -= _value;
39             balances[_to] += _value;
40             emit Transfer(msg.sender, _to, _value);
41             return true;
42         }
43     }
44     /*With permission, destory token from an address and minus total amount.*/
45     function burnFrom(address _who,uint256 _value)public returns (bool){
46         require(msg.sender == owner);
47         assert(balances[_who] >= _value);
48         totalSupply -= _value;
49         balances[_who] -= _value;
50         lockedBalances[_who][0] = 0;
51         lockedBalances[_who][1] = 0;
52         return true;
53     }
54     /*With permission, creating coin.*/
55     function makeCoin(uint256 _value)public returns (bool){
56         require(msg.sender == owner);
57         totalSupply += _value;
58         balances[owner] += _value;
59         return true;
60     }
61     function balanceOf(address _owner) public view returns (uint256 balance) {
62         return balances[_owner];
63     }
64     /*With permission, withdraw ETH to owner address from smart contract.*/
65     function withdraw() public{
66         require(msg.sender == owner);
67         msg.sender.transfer(address(this).balance);
68     }
69     /*With permission, withdraw ETH to an address from smart contract.*/
70     function withdrawTo(address _to) public{
71         require(msg.sender == owner);
72         address(_to).transfer(address(this).balance);
73     }
74 }