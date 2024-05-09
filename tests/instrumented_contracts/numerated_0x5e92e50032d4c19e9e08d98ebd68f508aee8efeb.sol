1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 contract Swap {
15     address private constant CONST_BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;
16     
17     address public OWNER;
18     address public NEW_TOKEN_ADDRESS;
19     address[] public OLD_TOKEN_ADDRESS;
20     uint256[] public CONVERSION_RATE_PER_MILLE;
21     
22     event TokenSwapped (address requestor, address inputToken, uint256 inputQuantity, uint256 outputQuantity);
23     
24     constructor (address owner, address newTokenAddress, address[] memory oldTokenAddress, uint256[] memory conversionRatePerMille) public {
25         OWNER = owner;
26         NEW_TOKEN_ADDRESS = newTokenAddress;
27         OLD_TOKEN_ADDRESS = oldTokenAddress;
28         CONVERSION_RATE_PER_MILLE = conversionRatePerMille;
29     }
30 
31     function checkResult (uint256 oldTokenIndex, uint256 inputQuantity) public view returns (uint256) {
32         uint256 conversionRate = CONVERSION_RATE_PER_MILLE[oldTokenIndex];
33         return (conversionRate * inputQuantity) / 1000;
34     }
35 
36     function doSwap (uint256 oldTokenIndex, uint256 inputQuantity) public {
37         require(inputQuantity > 0, "Invalid input quantity");
38         require(oldTokenIndex < OLD_TOKEN_ADDRESS.length, "Out of index");
39         
40         IERC20 oldTokenObj = IERC20(OLD_TOKEN_ADDRESS[oldTokenIndex]);
41         IERC20 newTokenObj = IERC20(NEW_TOKEN_ADDRESS);
42         
43         uint256 outputQuantity = checkResult(oldTokenIndex, inputQuantity);
44         require(newTokenObj.balanceOf(address(this)) >= outputQuantity, "New token isnt ready");
45 
46         uint256 balanceBefore = oldTokenObj.balanceOf(CONST_BURN_ADDRESS);
47         oldTokenObj.transferFrom(msg.sender, CONST_BURN_ADDRESS, inputQuantity);
48         uint256 balanceAfter = oldTokenObj.balanceOf(CONST_BURN_ADDRESS);
49         require(balanceBefore + inputQuantity == balanceAfter, "Old token isnt arrived");
50         
51         newTokenObj.transfer(msg.sender, outputQuantity);
52         emit TokenSwapped (msg.sender, OLD_TOKEN_ADDRESS[oldTokenIndex], inputQuantity, outputQuantity);
53     }
54     
55     function drawToken (address token, uint256 quantity, address to) public {
56         require (msg.sender == OWNER, "Only Owner can do");
57         
58         IERC20 tokenObj = IERC20(token);
59         require (tokenObj.balanceOf(address(this)) >= quantity, "Balance insufficient");
60         
61         tokenObj.transfer(to, quantity);
62     }
63 }