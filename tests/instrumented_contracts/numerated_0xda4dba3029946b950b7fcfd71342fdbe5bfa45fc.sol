1 pragma solidity ^0.5.8;
2 
3 contract Owned {
4     modifier onlyOwner() {
5         require(msg.sender == owner);
6         _;
7     }
8     address payable owner;
9     address payable newOwner;
10     function changeOwner(address payable _newOwner) public onlyOwner {
11         newOwner = _newOwner;
12     }
13     function acceptOwnership() public {
14         if (msg.sender == newOwner) {
15             owner = newOwner;
16         }
17     }
18 }
19 
20 contract Stake is Owned {
21     uint8 public fee;
22     uint32 public users;
23     string domain;
24     mapping (address=>uint256) stakes;
25     event Staked(address indexed _from, uint256 _value);
26     event Transfered(address indexed _from, address indexed _to, uint256 _value);
27     event Withdrawn(address indexed _from, uint256 _value);
28     function stakeOf(address _user) view public returns (uint256 stake) {return stakes[_user];}
29     function transferStake(address _from, address _to, uint256 _amount) public onlyOwner returns (bool ok){
30         require(_from!=address(0)&&_to!=address(0)&&_amount>0&&_amount<=stakes[_from]);
31         stakes[_from]-=_amount;
32         emit Transfered(_from,_to,_amount);
33         uint256 fees = _amount*fee/100;
34         _amount-=fees;
35         stakes[_to]+=_amount;
36         owner.transfer(fees);
37         return true;
38     }
39     function withdrawStake(address payable _from, uint256 _amount) public onlyOwner returns (bool ok){
40         require(_from!=address(0)&&_amount>0&&_amount<=stakes[_from]);
41         stakes[_from]-=_amount;
42         emit Withdrawn(_from,_amount);
43         if (_from==owner) owner.transfer(_amount);
44         else {
45             uint256 fees = _amount*fee/100;
46             _amount-=fees;
47             _from.transfer(_amount);
48             owner.transfer(fees);
49         }
50         return true;
51     }
52 }
53 
54 contract EtherBox is Stake{
55     
56     constructor() public{
57         fee = 1;
58         users = 0;
59         domain = 'www.etherbox.io';
60         owner = msg.sender;
61     }
62     
63     function () payable external {
64         require(msg.value>0);
65         if (stakes[msg.sender]==0) users++;
66         stakes[msg.sender]+=msg.value;
67         emit Staked(msg.sender,msg.value);
68     }
69 }