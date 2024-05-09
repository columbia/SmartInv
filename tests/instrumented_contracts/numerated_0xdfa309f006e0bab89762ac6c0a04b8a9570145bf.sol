1 pragma solidity ^0.4.24;
2 contract Ownable {
3     address public owner;
4     constructor() public {
5         owner = msg.sender;
6     }
7     modifier onlyOwner() {
8         require(msg.sender == owner);
9         _;
10     }
11 }
12 contract Pausable is Ownable {
13     event Pause();
14     event Unpause();
15     bool public paused = false;
16     modifier whenNotPaused() {
17         require(!paused, "Contract Paused. Events/Transaction Paused until Further Notice");
18         _;
19     }
20     modifier whenPaused() {
21         require(paused, "Contract Functionality Resumed");
22         _;
23     }
24     function pause() onlyOwner whenNotPaused public {
25         paused = true;
26         emit Pause();
27     }
28     function unpause() onlyOwner whenPaused public {
29         paused = false;
30         emit Unpause();
31     }
32 }
33 contract ERC20Token {
34     function transferFrom(address _from, address _to, uint _value) public returns (bool);
35 }
36 contract Airdrop is Ownable, Pausable {
37     event TokenDrop(address indexed _from, address indexed _to, uint256 _value);
38     function drop(ERC20Token _token, address[] _recipients, uint256[] _values) public onlyOwner whenNotPaused {
39         for (uint256 i = 0; i < _recipients.length; i++) {
40             _token.transferFrom(msg.sender, _recipients[i], _values[i]);
41             emit TokenDrop(msg.sender, _recipients[i], _values[i]);
42         }
43     }
44 }