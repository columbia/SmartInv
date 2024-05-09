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
22     uint32 public stakers;
23     string public domain;
24     mapping (address=>uint256) stakes;
25     event Staked(address indexed _from, uint256 _value);
26     event Transfered(address indexed _from, address indexed _to, uint256 _value);
27     function stakeOf(address _user) view public returns (uint256 stake) {return stakes[_user];}
28     function transfer(address _to, uint256 _amount) public returns (bool ok){
29         require(_to!=address(0)&&_amount>100&&_amount<=stakes[msg.sender]);
30         stakes[msg.sender]-=_amount;
31         _amount-=payfee(_amount);
32         if (stakes[_to]==0) stakers++;
33         stakes[_to]+=_amount;
34         emit Transfered(msg.sender,_to,_amount);
35         return true;
36     }
37     function withdraw(uint256 _amount) public returns (bool ok){
38         require(_amount>100&&_amount<=stakes[msg.sender]);
39         stakes[msg.sender]-=_amount;
40         if (msg.sender==owner) owner.transfer(_amount);
41         else msg.sender.transfer(_amount-payfee(_amount));
42         return true;
43     }
44     function payfee(uint256 _amount) internal returns (uint256 fees){
45         if (msg.sender==owner) return 0;
46         fees = _amount*fee/100;
47         owner.transfer(fees);
48         return fees;
49     }
50 }
51 
52 contract EtherBoxStake is Stake{
53     
54     constructor() public{
55         fee = 1;
56         stakers = 0;
57         domain = 'www.etherbox.io';
58         owner = msg.sender;
59     }
60     
61     function () payable external {
62         require(msg.value>=100);
63         if (stakes[msg.sender]==0) stakers++;
64         stakes[msg.sender]+=msg.value-payfee(msg.value);
65         emit Staked(msg.sender,msg.value);
66     }
67 }