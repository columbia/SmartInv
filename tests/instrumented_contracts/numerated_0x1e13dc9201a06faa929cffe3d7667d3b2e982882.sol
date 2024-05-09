1 pragma solidity ^0.4.17;
2 
3 contract NovaAccessControl {
4   mapping (address => bool) managers;
5   address public cfoAddress;
6 
7   function NovaAccessControl() public {
8     managers[msg.sender] = true;
9   }
10 
11   modifier onlyManager() {
12     require(managers[msg.sender]);
13     _;
14   }
15 
16   function setManager(address _newManager) external onlyManager {
17     require(_newManager != address(0));
18     managers[_newManager] = true;
19   }
20 
21   function removeManager(address mangerAddress) external onlyManager {
22     require(mangerAddress != msg.sender);
23     managers[mangerAddress] = false;
24   }
25 
26   function updateCfo(address newCfoAddress) external onlyManager {
27     require(newCfoAddress != address(0));
28     cfoAddress = newCfoAddress;
29   }
30 }
31 
32 contract NovaCoin is NovaAccessControl {
33   string public name;
34   string public symbol;
35   uint256 public totalSupply;
36   address supplier;
37   // 1:1 convert with currency, so to cent
38   uint8 public decimals = 2;
39   mapping (address => uint256) public balanceOf;
40   address public novaContractAddress;
41 
42   event Transfer(address indexed from, address indexed to, uint256 value);
43   event Burn(address indexed from, uint256 value);
44   event NovaCoinTransfer(address indexed to, uint256 value);
45 
46   function NovaCoin(uint256 initialSupply, string tokenName, string tokenSymbol) public {
47     totalSupply = initialSupply * 10 ** uint256(decimals);
48     supplier = msg.sender;
49     balanceOf[supplier] = totalSupply;
50     name = tokenName;
51     symbol = tokenSymbol;
52   }
53 
54   function _transfer(address _from, address _to, uint _value) internal {
55     require(_to != 0x0);
56     require(balanceOf[_from] >= _value);
57     require(balanceOf[_to] + _value > balanceOf[_to]);
58     balanceOf[_from] -= _value;
59     balanceOf[_to] += _value;
60   }
61 
62   function transfer(address _to, uint256 _value) external {
63     _transfer(msg.sender, _to, _value);
64     Transfer(msg.sender, _to, _value);
65   }
66 
67   function novaTransfer(address _to, uint256 _value) external onlyManager {
68     _transfer(supplier, _to, _value);
69     NovaCoinTransfer(_to, _value);
70   }
71 
72   function updateNovaContractAddress(address novaAddress) external onlyManager {
73     novaContractAddress = novaAddress;
74   }
75 
76   function consumeCoinForNova(address _from, uint _value) external {
77     require(msg.sender == novaContractAddress);
78     _transfer(_from, novaContractAddress, _value);
79   }
80 }