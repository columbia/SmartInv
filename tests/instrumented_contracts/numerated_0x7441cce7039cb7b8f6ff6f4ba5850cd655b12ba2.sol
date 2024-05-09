1 pragma solidity ^0.5.3;
2 
3 contract TubLike {
4     function safe(bytes32 cup) external returns (bool);
5     function cups(bytes32 cup) external view returns (address,uint,uint,uint);
6 }
7 
8 contract GemLike {
9     function balanceOf(address guy) external view returns (uint256);
10     function transfer(address dst, uint256 wad) external returns (bool);
11 }
12 
13 contract RiskyBusiness {
14 
15     address public owner;
16     uint256 public min;
17 
18     mapping (bytes32 => bool) public played;
19 
20     TubLike public constant tub = TubLike(0x448a5065aeBB8E423F0896E6c5D525C040f59af3);
21     GemLike public constant dai = GemLike(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
22 
23     constructor(uint256 min_) public {
24         owner = msg.sender;
25         min = min_;
26     }
27 
28     modifier auth {
29         require(msg.sender == owner, "risky-biz: you are not Mariano!");
30         _;
31     }
32 
33     function play(uint256 cup) external returns (bool) {
34         bytes32 id = bytes32(cup);
35         (address lad, , uint art, ) = tub.cups(id);
36 
37         require(msg.sender == lad, "risky-biz: sender is not cdp owner");
38         require(art >= min, "risky-biz: not enough debt in cdp");
39         require(!tub.safe(id), "risky-biz: cdp is not unsafe");
40         require(!played[id], "risky-biz: this cdp has already played");
41         
42         played[id] = true;
43         return dai.transfer(msg.sender, dai.balanceOf(address(this)));
44     }
45 
46     function setMin(uint256 min_) external auth {
47         min = min_;
48     }
49 
50     function totallyNotABackdoorToRetrieveMyDaiJustInCase() external auth returns (bool) {
51         uint wad = dai.balanceOf(address(this));
52         return dai.transfer(msg.sender, wad);
53     }
54 }