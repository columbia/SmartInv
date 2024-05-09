1 pragma solidity ^0.4.21;
2 
3 contract Owned {
4     address public owner;
5 
6     event TransferOwnership(address oldaddr, address newaddr);
7 
8     modifier onlyOwner() { if (msg.sender != owner) return; _; }
9 
10     function Owned() public {
11         owner = msg.sender;
12     }
13     
14     function transferOwnership(address _new) onlyOwner public {
15         address oldaddr = owner;
16         owner = _new;
17         emit TransferOwnership(oldaddr, owner);
18     }
19 }
20 
21 contract ERC20Interface {
22 	uint256 public totalSupply;
23 	function balanceOf(address _owner) public constant returns (uint256 balance);
24 	function transfer(address _to, uint256 _value) public returns (bool success);
25 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
26 	function approve(address _spender, uint256 _value) public returns (bool success);
27 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
28 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
29 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 }
31 
32 contract DACVest is Owned {
33     uint256 constant public initialVestAmount = 880000000 ether;
34 
35     uint256 constant public start = 1533081600; // 2018/08/01
36     uint256 constant public phaseDuration = 30 days;
37     uint256 constant public phaseReleaseAmount = 176000000 ether;
38 
39     uint256 public latestPhaseNumber = 0;
40     bool public ready = false;
41 
42     ERC20Interface constant public DACContract = ERC20Interface(0xAAD54C9f27B876D2538455DdA69207279fF673a5);
43 
44     function DACVest() public {
45         
46     }
47 
48     function setup() onlyOwner public {
49         ready = true;
50         require(DACContract.transferFrom(owner, this, initialVestAmount));
51     }
52 
53     function release() onlyOwner public {
54         require(ready);
55         require(now > start);
56 
57         uint256 currentPhaseNumber = (now - start) / phaseDuration + 1;
58         require(currentPhaseNumber > latestPhaseNumber);
59 
60         uint256 maxReleaseAmount = (currentPhaseNumber - latestPhaseNumber) * phaseReleaseAmount;
61         latestPhaseNumber = currentPhaseNumber;
62         uint256 tokenBalance = DACContract.balanceOf(this);
63         uint256 returnAmount = maxReleaseAmount > tokenBalance ? tokenBalance : maxReleaseAmount;
64 
65         require(DACContract.transfer(owner, returnAmount));
66     }
67 }