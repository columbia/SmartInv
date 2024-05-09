1 pragma solidity ^0.5.8;
2 
3 interface ERC20 {
4     function transfer(address _to, uint256 _value) external returns (bool);
5 }
6 
7 contract Ownable {
8     address public owner;
9     
10     event SetOwner(address _prev, address _new);
11     
12     constructor() public {
13         emit SetOwner(owner, msg.sender);
14         owner = msg.sender;
15     }
16     
17     modifier onlyOwner() {
18         require(msg.sender == owner, "Only owner");
19         _;
20     }
21     
22     function setOwner(address _owner) external onlyOwner {
23         emit SetOwner(owner, _owner);
24         owner = _owner;
25     }
26 }
27 
28 contract Lock is Ownable {
29     uint256 public constant MAX_LOCK_JUMP = 86400 * 365; // 1 year
30 
31     uint256 public lock;
32 
33     event SetLock(uint256 _prev, uint256 _new);
34     
35     constructor() public {
36         lock = now;
37         emit SetLock(0, now);
38     }
39     
40     modifier onUnlocked() {
41         require(now >= lock, "Wallet locked");
42         _;
43     }
44     
45     function setLock(uint256 _lock) external onlyOwner {
46         require(_lock > lock, "Can't set lock to past");
47         require(_lock - lock <= MAX_LOCK_JUMP, "Max lock jump exceeded");
48         emit SetLock(lock, _lock);
49         lock = _lock;
50     }
51 
52     function withdraw(ERC20 _token, address _to, uint256 _value) external onlyOwner onUnlocked returns (bool) {
53         return _token.transfer(_to, _value);
54     }
55     
56     function call(address payable _to, uint256 _value, bytes calldata _data) external onlyOwner onUnlocked returns (bool, bytes memory) {
57         return _to.call.value(_value)(_data);
58     }
59 }