// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// $MULLET
// - 1 billion supply
// - no contract owner
// - 100% of tokens in initial LP
// - LP locked in contract permanently
// - V3 LP with a 5 ETH initial market cap
// - 1,000,000 token max transfer for 5 minutes
// https://mullet.capital

// $HAIR
// - fully liquid without the need for a DEX
// - 10% buy/sell tax
// - tax distributed to token holders in the form of ETH
// - referral link, own 100 $HAIR or more to get 3% of referred buys/reinvests
// https://hedge.mullet.capital


interface Callable {
	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
}

interface Router {
	struct ExactInputSingleParams {
		address tokenIn;
		address tokenOut;
		uint24 fee;
		address recipient;
		uint256 amountIn;
		uint256 amountOutMinimum;
		uint160 sqrtPriceLimitX96;
	}
	function factory() external view returns (address);
	function positionManager() external view returns (address);
	function WETH9() external view returns (address);
	function exactInputSingle(ExactInputSingleParams calldata) external payable returns (uint256);
}

interface Factory {
	function createPool(address _tokenA, address _tokenB, uint24 _fee) external returns (address);
}

interface Pool {
	function initialize(uint160 _sqrtPriceX96) external;
}

interface PositionManager {
	struct MintParams {
		address token0;
		address token1;
		uint24 fee;
		int24 tickLower;
		int24 tickUpper;
		uint256 amount0Desired;
		uint256 amount1Desired;
		uint256 amount0Min;
		uint256 amount1Min;
		address recipient;
		uint256 deadline;
	}
	struct CollectParams {
		uint256 tokenId;
		address recipient;
		uint128 amount0Max;
		uint128 amount1Max;
	}
	function mint(MintParams calldata) external payable returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
	function collect(CollectParams calldata) external payable returns (uint256 amount0, uint256 amount1);
}

interface ERC20 {
	function balanceOf(address) external view returns (uint256);
	function transfer(address, uint256) external returns (bool);
}

interface WETH is ERC20 {
	function withdraw(uint256) external;
}


contract HEDGE {

	uint256 constant private FLOAT_SCALAR = 2**64;
	uint256 constant private BUY_TAX = 10;
	uint256 constant private SELL_TAX = 10;
	uint256 constant private TEAM_TAX = 1;
	uint256 constant private REF_TAX = 3;
	uint256 constant private REF_REQUIREMENT = 1e20; // 100 HAIR
	uint256 constant private STARTING_PRICE = 0.001 ether;
	uint256 constant private INCREMENT = 1e10; // 10 Gwei
	address constant private BUYBACK_ADDRESS = 0xA093Ea0904250084411F98d9195567e8b4406696;

	string constant public name = "HEDGE";
	string constant public symbol = "HAIR";
	uint8 constant public decimals = 18;

	struct User {
		uint256 balance;
		mapping(address => uint256) allowance;
		int256 scaledPayout;
		address ref;
	}

	struct Info {
		uint256 totalSupply;
		mapping(address => User) users;
		uint256 scaledEthPerToken;
		address team;
	}
	Info private info;


	event Transfer(address indexed from, address indexed to, uint256 tokens);
	event Approval(address indexed owner, address indexed spender, uint256 tokens);
	event Buy(address indexed buyer, uint256 amountSpent, uint256 tokensReceived);
	event Sell(address indexed seller, uint256 tokensSpent, uint256 amountReceived);
	event Withdraw(address indexed user, uint256 amount);
	event Reinvest(address indexed user, uint256 amount);


	constructor() {
		info.team = msg.sender;
	}
	
	receive() external payable {
		buy();
	}
	
	function buy() public payable returns (uint256) {
		return buy(address(0x0));
	}
	
	function buy(address _ref) public payable returns (uint256) {
		require(msg.value > 0);
		if (_ref != address(0x0) && _ref != msg.sender && _ref != refOf(msg.sender)) {
			info.users[msg.sender].ref = _ref;
		}
		return _buy(msg.value);
	}

	function sell(uint256 _tokens) external returns (uint256) {
		return _sell(_tokens);
	}

	function withdraw() external returns (uint256) {
		uint256 _rewards = rewardsOf(msg.sender);
		require(_rewards >= 0);
		info.users[msg.sender].scaledPayout += int256(_rewards * FLOAT_SCALAR);
		payable(msg.sender).transfer(_rewards);
		emit Withdraw(msg.sender, _rewards);
		return _rewards;
	}

	function reinvest() external returns (uint256) {
		uint256 _rewards = rewardsOf(msg.sender);
		require(_rewards >= 0);
		info.users[msg.sender].scaledPayout += int256(_rewards * FLOAT_SCALAR);
		emit Reinvest(msg.sender, _rewards);
		return _buy(_rewards);
	}

	function transfer(address _to, uint256 _tokens) external returns (bool) {
		return _transfer(msg.sender, _to, _tokens);
	}

	function approve(address _spender, uint256 _tokens) external returns (bool) {
		info.users[msg.sender].allowance[_spender] = _tokens;
		emit Approval(msg.sender, _spender, _tokens);
		return true;
	}

	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
		require(allowance(_from, msg.sender) >= _tokens);
		info.users[_from].allowance[msg.sender] -= _tokens;
		return _transfer(_from, _to, _tokens);
	}

	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
		_transfer(msg.sender, _to, _tokens);
		uint32 _size;
		assembly {
			_size := extcodesize(_to)
		}
		if (_size > 0) {
			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
		}
		return true;
	}


	function team() public view returns (address) {
		return info.team;
	}

	function buybackAddress() public pure returns (address) {
		return BUYBACK_ADDRESS;
	}

	function totalSupply() public view returns (uint256) {
		return info.totalSupply;
	}

	function currentPrices() public view returns (uint256 truePrice, uint256 buyPrice, uint256 sellPrice) {
		truePrice = STARTING_PRICE + INCREMENT * totalSupply() / 1e18;
		buyPrice = truePrice * 100 / (100 - BUY_TAX);
		sellPrice = truePrice * (100 - SELL_TAX) / 100;
	}

	function refOf(address _user) public view returns (address) {
		return info.users[_user].ref;
	}

	function balanceOf(address _user) public view returns (uint256) {
		return info.users[_user].balance;
	}

	function rewardsOf(address _user) public view returns (uint256) {
		return uint256(int256(info.scaledEthPerToken * balanceOf(_user)) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
	}

	function allInfoFor(address _user) public view returns (uint256 contractBalance, uint256 totalTokenSupply, uint256 truePrice, uint256 buyPrice, uint256 sellPrice, uint256 userETH, uint256 userBalance, uint256 userRewards, uint256 userLiquidValue, address userRef) {
		contractBalance = address(this).balance;
		totalTokenSupply = totalSupply();
		(truePrice, buyPrice, sellPrice) = currentPrices();
		userETH = _user.balance;
		userBalance = balanceOf(_user);
		userRewards = rewardsOf(_user);
		userLiquidValue = calculateResult(userBalance, false, false) + userRewards;
		userRef = refOf(_user);
	}

	function allowance(address _user, address _spender) public view returns (uint256) {
		return info.users[_user].allowance[_spender];
	}

	function calculateResult(uint256 _amount, bool _isBuy, bool _inverse) public view returns (uint256) {
		unchecked {
			uint256 _buyPrice;
			uint256 _sellPrice;
			( , _buyPrice, _sellPrice) = currentPrices();
			uint256 _rate = (_isBuy ? _buyPrice : _sellPrice);
			uint256 _increment = INCREMENT * (_isBuy ? 100 : (100 - SELL_TAX)) / (_isBuy ? (100 - BUY_TAX) : 100);
			if ((_isBuy && !_inverse) || (!_isBuy && _inverse)) {
				if (_inverse) {
					return (2 * _rate - _sqrt(4 * _rate * _rate + _increment * _increment - 4 * _rate * _increment - 8 * _amount * _increment) - _increment) * 1e18 / (2 * _increment);
				} else {
					return (_sqrt((_increment + 2 * _rate) * (_increment + 2 * _rate) + 8 * _amount * _increment) - _increment - 2 * _rate) * 1e18 / (2 * _increment);
				}
			} else {
				if (_inverse) {
					return (_rate * _amount + (_increment * (_amount + 1e18) / 2e18) * _amount) / 1e18;
				} else {
					return (_rate * _amount - (_increment * (_amount + 1e18) / 2e18) * _amount) / 1e18;
				}
			}
		}
	}


	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
		require(balanceOf(_from) >= _tokens);
		info.users[_from].balance -= _tokens;
		info.users[_from].scaledPayout -= int256(_tokens * info.scaledEthPerToken);
		info.users[_to].balance += _tokens;
		info.users[_to].scaledPayout += int256(_tokens * info.scaledEthPerToken);
		emit Transfer(_from, _to, _tokens);
		return true;
	}

	function _buy(uint256 _amount) internal returns (uint256 tokens) {
		uint256 _tax = _amount * BUY_TAX / 100;
		tokens = calculateResult(_amount, true, false);
		info.totalSupply += tokens;
		info.users[msg.sender].balance += tokens;
		info.users[msg.sender].scaledPayout += int256(tokens * info.scaledEthPerToken);
		uint256 _teamTax = _amount * TEAM_TAX / 100;
		info.users[team()].scaledPayout -= int256(_teamTax * FLOAT_SCALAR);
		uint256 _refTax = _amount * REF_TAX / 100;
		address _ref = refOf(msg.sender);
		if (_ref != address(0x0) && balanceOf(_ref) >= REF_REQUIREMENT) {
			info.users[_ref].scaledPayout -= int256(_refTax * FLOAT_SCALAR);
		} else {
			info.users[buybackAddress()].scaledPayout -= int256(_refTax * FLOAT_SCALAR);
		}
		info.scaledEthPerToken += (_tax - _teamTax - _refTax) * FLOAT_SCALAR / info.totalSupply;
		emit Transfer(address(0x0), msg.sender, tokens);
		emit Buy(msg.sender, _amount, tokens);
	}

	function _sell(uint256 _tokens) internal returns (uint256 amount) {
		require(balanceOf(msg.sender) >= _tokens);
		amount = calculateResult(_tokens, false, false);
		uint256 _tax = amount * SELL_TAX / (100 - SELL_TAX);
		info.totalSupply -= _tokens;
		info.users[msg.sender].balance -= _tokens;
		info.users[msg.sender].scaledPayout -= int256(_tokens * info.scaledEthPerToken);
		uint256 _teamTax = amount * TEAM_TAX / (100 - SELL_TAX);
		info.users[team()].scaledPayout -= int256(_teamTax * FLOAT_SCALAR);
		info.scaledEthPerToken += (_tax - _teamTax) * FLOAT_SCALAR / info.totalSupply;
		payable(msg.sender).transfer(amount);
		emit Transfer(msg.sender, address(0x0), _tokens);
		emit Sell(msg.sender, _tokens, amount);
	}


	function _sqrt(uint256 _n) internal pure returns (uint256 result) {
		unchecked {
			uint256 _tmp = (_n + 1) / 2;
			result = _n;
			while (_tmp < result) {
				result = _tmp;
				_tmp = (_n / _tmp + _tmp) / 2;
			}
		}
	}
}


contract Team {

	Router constant private ROUTER = Router(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);

	struct Share {
		address payable user;
		uint256 shares;
	}
	Share[] public shares;
	uint256 public totalShares;
	ERC20 immutable public token;
	HEDGE immutable public hedge;


	constructor() {
		token = ERC20(msg.sender);
		hedge = new HEDGE();
		_addShare(0x7178523CD70c5E96C079701fE46Cda3E1799b4Ce, 9);
		_addShare(0xc61D594dff6D253142C7Fa83F41D318F157B018a, 9);
		_addShare(0x2000Af01b455C4cd3E65AED180eC3EE52BD6C264, 2);
	}

	receive() external payable {}

	function withdrawETH() public {
		uint256 _balance = address(this).balance;
		if (_balance > 0) {
			for (uint256 i = 0; i < shares.length; i++) {
				Share memory _share = shares[i];
				!_share.user.send(_balance * _share.shares / totalShares);
			}
		}
	}

	function withdrawHAIR() external {
		hedge.withdraw();
		withdrawETH();
	}

	function withdrawToken(ERC20 _token) public {
		WETH _weth = WETH(ROUTER.WETH9());
		if (address(_token) == address(_weth)) {
			_weth.withdraw(_weth.balanceOf(address(this)));
			withdrawETH();
		} else {
			uint256 _balance = _token.balanceOf(address(this));
			if (_balance > 0) {
				for (uint256 i = 0; i < shares.length; i++) {
					Share memory _share = shares[i];
					_token.transfer(_share.user, _balance * _share.shares / totalShares);
				}
			}
		}
	}

	function withdrawWETH() public {
		withdrawToken(ERC20(ROUTER.WETH9()));
	}

	function withdrawFees() external {
		withdrawWETH();
		withdrawToken(token);
	}


	function _addShare(address _user, uint256 _shares) internal {
		shares.push(Share(payable(_user), _shares));
		totalShares += _shares;
	}
}


contract Ambassadors {

	struct Share {
		address payable user;
		uint256 shares;
	}
	Share[] public shares;
	uint256 public totalShares;
	ERC20 immutable public token;


	constructor() {
		token = ERC20(msg.sender);
		_addShare(0x1427798f129b92F19927931a964D17bd6C2F5253, 10);
		_addShare(0x9D756A1848Ee62db36C17f000699f65BfEF9bf11, 7);
		_addShare(0x1248E5Ce0dB0F869A9A934b1677bd5A17e5B8DFe, 7);
		_addShare(0x6A5da854d5a3A0Fc4A760Bc6A9062D2A8e36431a, 7);
		_addShare(0x5a02FbCE3B19E9508F5Cc7F351f671795c1a81a4, 7);
		_addShare(0x1B1B694c797904D9B84ed636661C32C4DcaA17d9, 7);
		_addShare(0x492bb59126d7F06C2c5B13cD50caD209a43eA326, 7);
		_addShare(0x60d5567d7f8d05C899C89e63E00E4f6ca396ec13, 7);
		_addShare(0xBaE44b530f65Aa9A97bb0d17b4eafb07Ac67259C, 7);
		_addShare(0xe6eD771d0deC3a1F5B1A9bBc90fF9353E7Ec9c56, 7);
		_addShare(0xc44241b85051E5837B522289B2559d70496B16dC, 7);
		_addShare(0x0539480eE00A547974e7E38c1A9c8b046d767F22, 7);
		_addShare(0x7a3DD779b524C80e464B23AfCA6906539Df958D0, 7);
		_addShare(0xDfCE959d59F3E34c4f018cd91E4A5B9453Ff2D7d, 7);
		_addShare(0xAc537fcf993fAbCA3e795658B5b1a06c5DEC1e85, 7);
		_addShare(0x0d9997acB3f204fe3A09aCB1Fd594F906bCc88BB, 7);
		_addShare(0x6a49351D350245cFA979c1EBce7D18ADa46406d5, 7);
		_addShare(0x8E44aF6308e52b94157Ec9A898eC9f31cc1B0E16, 7);
		_addShare(0xf939FDa6330984F3E84EB32701bd404dACc27D50, 7);
		_addShare(0x29f3536D4E2a790f11d5827490390Dd1dca3e9b1, 7);
		_addShare(0xA4C501D7Cd0914fCfDb9E2bf367cC224a4531fAc, 7);
		_addShare(0x5dBFEAcf8f26e83314790f3Ee91eEAB97617F734, 7);
		_addShare(0xEBf184353dD81C21AAaB257143346584d75d1537, 7);
		_addShare(0xdAf028effC6e75307c54899a433b40514fEBB936, 7);
		_addShare(0xC4be049c2835D5F42c3B11a44c775F8A4909bd5F, 7);
		_addShare(0xD89eF44a1fBeA729912Fc40CAcF7d0CAe2A49841, 7);
		_addShare(0x5E056D473F95eA7Ef9660a46310297b2D457cAaD, 7);
		_addShare(0xb592016Dc145aFBA2aeE5B35e2Dfe0629BF83A36, 4);
		_addShare(0x95f572bD843b74C0d582b1BE5AF2583293ad2255, 2);
	}

	function distribute() external {
		uint256 _balance = token.balanceOf(address(this));
		if (_balance > 0) {
			for (uint256 i = 0; i < shares.length; i++) {
				Share memory _share = shares[i];
				token.transfer(_share.user, _balance * _share.shares / totalShares);
			}
		}
	}


	function _addShare(address _user, uint256 _shares) internal {
		shares.push(Share(payable(_user), _shares));
		totalShares += _shares;
	}
}


contract MULLET {

	uint256 constant private UINT_MAX = type(uint256).max;
	uint128 constant private UINT128_MAX = type(uint128).max;
	uint256 constant private INITIAL_SUPPLY = 1e27; // 1 billion
	Router constant private ROUTER = Router(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);
	uint256 constant private INITIAL_ETH_MC = 5 ether; // 5 ETH initial market cap price
	uint256 constant private UPPER_ETH_MC = 1e6 ether; // 1,000,000 ETH max market cap price
	uint256 constant private LIMIT_TIME = 5 minutes;
	uint256 constant private TOKEN_LIMIT = (INITIAL_SUPPLY / 1000); // max buy of 1m tokens, approx. 0.005 ETH, for 5 minutes

	int24 constant private MIN_TICK = -887272;
	int24 constant private MAX_TICK = -MIN_TICK;
	uint160 constant private MIN_SQRT_RATIO = 4295128739;
	uint160 constant private MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;

	string constant public name = "Mullet Money Mission";
	string constant public symbol = "MULLET";
	uint8 constant public decimals = 18;

	struct User {
		uint256 balance;
		mapping(address => uint256) allowance;
	}

	struct Info {
		Team team;
		address pool;
		uint256 totalSupply;
		mapping(address => User) users;
		uint128 positionId;
		uint128 startTime;
	}
	Info private info;


	event Transfer(address indexed from, address indexed to, uint256 tokens);
	event Approval(address indexed owner, address indexed spender, uint256 tokens);


	constructor() payable {
		require(msg.value > 0);
		info.team = new Team();
		address _this = address(this);
		address _weth = ROUTER.WETH9();
		(uint160 _initialSqrtPrice, ) = _getPriceAndTickFromValues(_weth < _this, INITIAL_SUPPLY, INITIAL_ETH_MC);
		info.pool = Factory(ROUTER.factory()).createPool(_this, _weth, 10000);
		Pool(pool()).initialize(_initialSqrtPrice);
	}
	
	function initialize() external {
		require(totalSupply() == 0);
		address _this = address(this);
		address _weth = ROUTER.WETH9();
		bool _weth0 = _weth < _this;
		PositionManager _pm = PositionManager(ROUTER.positionManager());
		info.totalSupply = INITIAL_SUPPLY;
		info.users[_this].balance = INITIAL_SUPPLY;
		emit Transfer(address(0x0), _this, INITIAL_SUPPLY);
		_approve(_this, address(_pm), INITIAL_SUPPLY);
		( , int24 _minTick) = _getPriceAndTickFromValues(_weth0, INITIAL_SUPPLY, INITIAL_ETH_MC);
		( , int24 _maxTick) = _getPriceAndTickFromValues(_weth0, INITIAL_SUPPLY, UPPER_ETH_MC);
		(uint256 _positionId, , , ) = _pm.mint(PositionManager.MintParams({
			token0: _weth0 ? _weth : _this,
			token1: !_weth0 ? _weth : _this,
			fee: 10000,
			tickLower: _weth0 ? _maxTick : _minTick,
			tickUpper: !_weth0 ? _maxTick : _minTick,
			amount0Desired: _weth0 ? 0 : INITIAL_SUPPLY,
			amount1Desired: !_weth0 ? 0 : INITIAL_SUPPLY,
			amount0Min: 0,
			amount1Min: 0,
			recipient: _this,
			deadline: block.timestamp
		}));
		info.positionId = uint128(_positionId);
		Ambassadors _ambassadors = new Ambassadors();
		ROUTER.exactInputSingle{value:_this.balance}(Router.ExactInputSingleParams({
			tokenIn: _weth,
			tokenOut: _this,
			fee: 10000,
			recipient: address(_ambassadors),
			amountIn: _this.balance,
			amountOutMinimum: 0,
			sqrtPriceLimitX96: 0
		}));
		_ambassadors.distribute();
		info.startTime = uint128(block.timestamp);
	}

	function collectTradingFees() external {
		PositionManager(ROUTER.positionManager()).collect(PositionManager.CollectParams({
			tokenId: position(),
			recipient: team(),
			amount0Max: UINT128_MAX,
			amount1Max: UINT128_MAX
		}));
		info.team.withdrawFees();
	}

	function transfer(address _to, uint256 _tokens) external returns (bool) {
		return _transfer(msg.sender, _to, _tokens);
	}

	function approve(address _spender, uint256 _tokens) external returns (bool) {
		return _approve(msg.sender, _spender, _tokens);
	}

	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
		uint256 _allowance = allowance(_from, msg.sender);
		require(_allowance >= _tokens);
		if (_allowance != UINT_MAX) {
			info.users[_from].allowance[msg.sender] -= _tokens;
		}
		return _transfer(_from, _to, _tokens);
	}

	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
		_transfer(msg.sender, _to, _tokens);
		uint32 _size;
		assembly {
			_size := extcodesize(_to)
		}
		if (_size > 0) {
			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
		}
		return true;
	}
	

	function team() public view returns (address) {
		return address(info.team);
	}

	function pool() public view returns (address) {
		return info.pool;
	}

	function totalSupply() public view returns (uint256) {
		return info.totalSupply;
	}

	function balanceOf(address _user) public view returns (uint256) {
		return info.users[_user].balance;
	}

	function allowance(address _user, address _spender) public view returns (uint256) {
		return info.users[_user].allowance[_spender];
	}

	function position() public view returns (uint256) {
		return info.positionId;
	}


	function _approve(address _owner, address _spender, uint256 _tokens) internal returns (bool) {
		info.users[_owner].allowance[_spender] = _tokens;
		emit Approval(_owner, _spender, _tokens);
		return true;
	}
	
	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
		unchecked {
			if (block.timestamp < info.startTime + LIMIT_TIME) {
				require(_tokens <= TOKEN_LIMIT);
			}
			require(balanceOf(_from) >= _tokens);
			info.users[_from].balance -= _tokens;
			info.users[_to].balance += _tokens;
			emit Transfer(_from, _to, _tokens);
			return true;
		}
	}


	function _getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
		unchecked {
			uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
			require(absTick <= uint256(int256(MAX_TICK)), 'T');

			uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
			if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
			if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
			if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
			if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
			if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
			if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
			if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
			if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
			if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
			if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
			if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
			if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
			if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
			if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
			if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
			if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
			if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
			if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
			if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;

			if (tick > 0) ratio = type(uint256).max / ratio;

			sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
		}
	}

	function _getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
		unchecked {
			require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
			uint256 ratio = uint256(sqrtPriceX96) << 32;

			uint256 r = ratio;
			uint256 msb = 0;

			assembly {
				let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
				msb := or(msb, f)
				r := shr(f, r)
			}
			assembly {
				let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
				msb := or(msb, f)
				r := shr(f, r)
			}
			assembly {
				let f := shl(5, gt(r, 0xFFFFFFFF))
				msb := or(msb, f)
				r := shr(f, r)
			}
			assembly {
				let f := shl(4, gt(r, 0xFFFF))
				msb := or(msb, f)
				r := shr(f, r)
			}
			assembly {
				let f := shl(3, gt(r, 0xFF))
				msb := or(msb, f)
				r := shr(f, r)
			}
			assembly {
				let f := shl(2, gt(r, 0xF))
				msb := or(msb, f)
				r := shr(f, r)
			}
			assembly {
				let f := shl(1, gt(r, 0x3))
				msb := or(msb, f)
				r := shr(f, r)
			}
			assembly {
				let f := gt(r, 0x1)
				msb := or(msb, f)
			}

			if (msb >= 128) r = ratio >> (msb - 127);
			else r = ratio << (127 - msb);

			int256 log_2 = (int256(msb) - 128) << 64;

			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(63, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(62, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(61, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(60, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(59, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(58, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(57, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(56, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(55, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(54, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(53, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(52, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(51, f))
				r := shr(f, r)
			}
			assembly {
				r := shr(127, mul(r, r))
				let f := shr(128, r)
				log_2 := or(log_2, shl(50, f))
			}

			int256 log_sqrt10001 = log_2 * 255738958999603826347141;

			int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
			int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);

			tick = tickLow == tickHi ? tickLow : _getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
		}
	}

	function _sqrt(uint256 _n) internal pure returns (uint256 result) {
		unchecked {
			uint256 _tmp = (_n + 1) / 2;
			result = _n;
			while (_tmp < result) {
				result = _tmp;
				_tmp = (_n / _tmp + _tmp) / 2;
			}
		}
	}

	function _getPriceAndTickFromValues(bool _weth0, uint256 _tokens, uint256 _weth) internal pure returns (uint160 price, int24 tick) {
		uint160 _tmpPrice = uint160(_sqrt(2**192 / (!_weth0 ? _tokens : _weth) * (_weth0 ? _tokens : _weth)));
		tick = _getTickAtSqrtRatio(_tmpPrice);
		tick = tick - (tick % 200);
		price = _getSqrtRatioAtTick(tick);
	}
}


contract Deploy {
	MULLET immutable public mullet;
	HEDGE immutable public hedge;
	constructor() payable {
		mullet = new MULLET{value:msg.value}();
		mullet.initialize();
		hedge = HEDGE(Team(payable(mullet.team())).hedge());
	}
}