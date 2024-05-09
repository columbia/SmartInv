1 /**
2  *Submitted for verification at Etherscan.io on 2019-11-06
3 */
4 
5 pragma solidity 0.5.11;
6 pragma experimental ABIEncoderV2;
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14     address public owner;
15 
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19 
20     /**
21      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22      * account.
23      */
24     constructor() public {
25         owner = msg.sender;
26     }
27 
28     /**
29      * @dev Throws if called by any account other than the owner.
30      */
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     /**
37      * @dev Allows the current owner to transfer control of the contract to a newOwner.
38      * @param newOwner The address to transfer ownership to.
39      */
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 
46 }
47 contract ERC20BasicInterface {
48     function totalSupply() public view returns (uint256);
49 
50     function balanceOf(address who) public view returns (uint256);
51 
52     function transfer(address to, uint256 value) public returns (bool);
53 
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 
58     uint8 public decimals;
59 }
60 contract GachaDrop is Ownable {
61     struct Drop {
62         string name;
63         uint periodToPlay;
64         address erc20Need;
65         uint256 requireErc20;
66         mapping(address => uint) timeTrackUser;
67         uint countCallTime;
68     }
69     mapping(string => Drop) public Drops;
70     string[] public DropNames;
71     event _random(address _from, uint _ticket, string _drop, uint _countCallTime);
72     event _changePeriodToPlay(string _drop, uint _period);
73 
74     constructor() public {
75         Drops['avatarofwar'].name = 'avatarofwar';
76         Drops['avatarofwar'].periodToPlay = 86400;
77         Drops['avatarofwar'].erc20Need = 0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba;
78         // Drops['AvatarOfWar'].erc20Need = 0x91013928b1C4dbd0D5cB21BA5b052BfD840A7a7F; // hbwallet rinkeby
79         // Drops['avatarofwar'].erc20Need = 0x614F3262c6df42b174cF8544454D6Dc39A9768D2; // kovan
80         Drops['avatarofwar'].requireErc20 = 0;
81         DropNames.push('avatarofwar');
82     }
83     function getDropNames() public view returns(string[] memory) {
84         return DropNames;
85     }
86     function getTimeTrackUser(string memory _drop, address _player) public view returns(uint _periodToPlay, uint _timeTrackUser, uint _countCallTime) {
87         return (Drops[_drop].periodToPlay, Drops[_drop].timeTrackUser[_player], Drops[_drop].countCallTime);
88     }
89     function getAward(string memory _drop) public {
90         require(isValidToPlay(_drop));
91         Drops[_drop].timeTrackUser[msg.sender] = block.timestamp;
92         Drops[_drop].countCallTime = Drops[_drop].countCallTime + 1;
93         emit _random(msg.sender, block.timestamp, Drops[_drop].name, Drops[_drop].countCallTime);
94     }
95 
96     function isValidToPlay(string memory _drop) public view returns (bool){
97         ERC20BasicInterface erc20 = ERC20BasicInterface(Drops[_drop].erc20Need);
98         return Drops[_drop].periodToPlay <= now - Drops[_drop].timeTrackUser[msg.sender]
99         && erc20.balanceOf(msg.sender) >= Drops[_drop].requireErc20;
100     }
101     function changePeriodToPlay(string memory _drop, uint _period, address _erc20Need, uint256 _requireErc20) onlyOwner public{
102 
103         if(Drops[_drop].periodToPlay == 0) {
104             DropNames.push(_drop);
105             Drops[_drop].name = _drop;
106         }
107 
108         Drops[_drop].periodToPlay = _period;
109         Drops[_drop].erc20Need = _erc20Need;
110         Drops[_drop].requireErc20 = _requireErc20;
111         emit _changePeriodToPlay(_drop, _period);
112     }
113 
114 }