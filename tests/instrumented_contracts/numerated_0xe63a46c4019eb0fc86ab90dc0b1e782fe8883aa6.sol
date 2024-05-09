1 pragma solidity ^0.4.18;
2 
3 contract NashvilleBeerToken {
4   uint256 public maxSupply;
5   uint256 public totalSupply;
6   address public owner;
7   bytes32[] public redeemedList;
8   address constant public RECIPIENT = 0xB1384DfE8ac77a700F460C94352bdD47Dc0327eF; // Ethereum Meetup Donation Address
9   mapping (address => uint256) balances;
10 
11   event LogBeerClaimed(address indexed owner, uint256 date);
12   event LogBeerRedeemed(address indexed owner, bytes32 name, uint256 date);
13   event LogTransfer(address from, address indexed to, uint256 date);
14 
15   modifier onlyOwner {
16     require(owner == msg.sender);
17     _;
18   }
19 
20   function NashvilleBeerToken(uint256 _maxSupply) {
21     maxSupply = _maxSupply;
22     owner = msg.sender;
23   }
24 
25   function transfer(address _to, uint256 _amount) public returns(bool) {
26     require(balances[msg.sender] - _amount <= balances[msg.sender]);
27     balances[msg.sender] -= _amount;
28     balances[_to] += _amount;
29     LogTransfer(msg.sender, _to, now);
30   }
31 
32   function balanceOf(address _owner) public constant returns(uint) {
33     return balances[_owner];
34   }
35 
36   function redeemBeer(bytes32 _name) public returns(bool) {
37     require(balances[msg.sender] > 0);
38     balances[msg.sender]--;
39     redeemedList.push(_name);
40     LogBeerRedeemed(msg.sender, _name, now);
41   }
42 
43   function claimToken() public payable returns(bool) {
44     require(msg.value == 1 ether * 0.015);
45     require(totalSupply < maxSupply);
46     RECIPIENT.transfer(msg.value);
47     balances[msg.sender]++;
48     totalSupply++;
49     LogBeerClaimed(msg.sender, now);
50   }
51 
52   function assignToken(address _owner) public onlyOwner returns(bool) {
53     require(balances[_owner] == 0);
54     require(totalSupply < maxSupply);
55     balances[_owner]++;
56     totalSupply++;
57     LogBeerClaimed(_owner, now);
58   }
59 
60   function getRedeemedList() constant public returns (bytes32[]) {
61     bytes32[] memory list = new bytes32[](redeemedList.length);
62     for (uint256 i = 0; i < redeemedList.length; i++) {
63       list[i] = redeemedList[i];
64     }
65     return list;
66   }
67 }