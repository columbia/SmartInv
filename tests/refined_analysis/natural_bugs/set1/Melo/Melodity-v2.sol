// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Melodity is ERC20, ERC20Permit, ERC20Capped, AccessControl, ERC20Burnable {
    bytes32 public constant CROWDSALE_ROLE = 0x0000000000000000000000000000000000000000000000000000000000000001;

    event Bought(address account, uint256 amount);
    event Locked(address account, uint256 amount);
    event Released(address account, uint256 amount);

    struct Locks {
        uint256 locked;
        uint256 release_time;
        bool released;
    }

    uint256 public total_locked_amount = 0;

    mapping(address => Locks[]) private _locks;

	uint256 ICO_START = 1642147200;
	uint256 ICO_END = 1648771199;

    constructor() ERC20("Melodity", "MELD") ERC20Permit("Melodity") ERC20Capped(1000000000 * 10 ** decimals()) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        
		uint256 pow = 10 ** decimals();
		uint256 five_million = 5000000 * pow;
		uint256 fifty_million = five_million * 10;
		uint256 six_months = 60 * 60 * 24 * 180;
		uint256 one_year = six_months * 2;
		
		// set default lock for devs
		// devs funds are unlocked one time per year in a range of 4 years starting from the end of the ICO

		// Ebalo
		_mint(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), 4000000 * pow);
		insertLock(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), five_million, ICO_END - block.timestamp + one_year);
		insertLock(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), five_million, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), five_million, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), five_million, ICO_END - block.timestamp + one_year * 4);

		// RG
		_mint(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow);
		insertLock(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow, ICO_END - block.timestamp + one_year * 4);

		// WG
		_mint(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow);
		insertLock(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow, ICO_END - block.timestamp + one_year * 4);

		// Do inc - Company wallet
		_mint(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million);
		insertLock(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million, ICO_END - block.timestamp + one_year);
		insertLock(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million, ICO_END - block.timestamp + one_year * 4);

		// store the bridge funds (all preminted)
		_mint(address(0x7E097A68c0C4139f271912789d10062441017ee6), 125000000 * pow);


		//////////////////////////////
		//							//
		// donations locked as devs //
		//							//
		//////////////////////////////
		// donations from ebalo

		_mint(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow);
		insertLock(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow);
		insertLock(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow);
		insertLock(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow);
		insertLock(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow);
		insertLock(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow);
		insertLock(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow);
		insertLock(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow);
		insertLock(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow, ICO_END - block.timestamp + one_year * 4);

		// donations from rg

		_mint(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow);
		insertLock(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow);
		insertLock(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow);
		insertLock(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow);
		insertLock(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow);
		insertLock(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow);
		insertLock(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow);
		insertLock(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow, ICO_END - block.timestamp + one_year * 4);

		// donations from wg

		_mint(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow);
		insertLock(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow);
		insertLock(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow);
		insertLock(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow);
		insertLock(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow);
		insertLock(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow);
		insertLock(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow);
		insertLock(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow);
		insertLock(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow);
		insertLock(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow, ICO_END - block.timestamp + one_year * 4);

		_mint(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow);
		insertLock(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow, ICO_END - block.timestamp + one_year);
		insertLock(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
		insertLock(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
		insertLock(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow, ICO_END - block.timestamp + one_year * 4);
    }

    /**
     * @dev See {ERC20-_mint}.
     */
    function _mint(address account, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
        ERC20Capped._mint(account, amount);
    }

    /**
     * Lock the bought amount:
     *  - 10% released immediately
     *  - 15% released after 3 months
     *  - 25% released after 9 month (every 6 months starting from the third)
     *  - 25% released after 15 month (every 6 months starting from the third)
     *  - 25% released after 21 month (every 6 months starting from the third)
     */
    function saleLock(address account, uint256 _amount) public onlyRole(CROWDSALE_ROLE) {
        emit Bought(account, _amount);
        
        // immediately release the 10% of the bought amount
        uint256 immediately_released = _amount / 10; // * 10 / 100 = / 10

        // 15% released after 3 months
        uint256 m3_release = _amount * 15 / 100; 

        // 25% released after 9 months
        uint256 m9_release = _amount * 25 / 100; 
        
        // 25% released after 15 months
        uint256 m15_release = _amount * 25 / 100; 
        
        // 25% released after 21 months
        uint256 m21_release = _amount - (immediately_released + m3_release + m9_release + m15_release); 

        uint256 locked_amount = m3_release + m9_release + m15_release + m21_release;

        // update the counter
        total_locked_amount += locked_amount;

        Locks memory lock_m = Locks({
            locked: m3_release,
            release_time: block.timestamp + 7776000,    // 60s * 60m * 24h * 90d
            released: false
        }); 
		_locks[account].push(lock_m);

		lock_m.release_time = block.timestamp + 23328000; // 60s * 60m * 24h * 270d
		lock_m.locked = m9_release;
		_locks[account].push(lock_m);

		lock_m.release_time = block.timestamp + 38880000; // 60s * 60m * 24h * 450d
		lock_m.locked = m15_release;
		_locks[account].push(lock_m);

		lock_m.release_time = block.timestamp + 54432000; // 60s * 60m * 24h * 630d
		lock_m.locked = m21_release;
		_locks[account].push(lock_m);

        emit Locked(account, locked_amount);

        _mint(account, immediately_released);
        emit Released(account, immediately_released);
    }

	function burnUnsold(uint256 _amount) public onlyRole(CROWDSALE_ROLE) {
		_mint(address(0), _amount);
	}

	/**
	 * Lock the provided amount of MELD for "_relative_release_time" seconds starting from now
	 * NOTE: This method is capped 
	 * NOTE: time definition in the locks is relative!
	 */
    function insertLock(address account, uint256 _amount, uint256 _relative_release_time) public onlyRole(DEFAULT_ADMIN_ROLE) {
		require(totalSupply() + total_locked_amount + _amount <= cap(), "Unable to lock the defined amount, cap exceeded");
		Locks memory lock_ = Locks({
            locked: _amount,
            release_time: block.timestamp + _relative_release_time,
            released: false
        }); 
		_locks[account].push(lock_);

		total_locked_amount += _amount;

		emit Locked(account, _amount);
    }

	/**
	 * Insert an array of locks for the provided account
	 * NOTE: time definition in the locks is relative!
	 */
    function batchInsertLock(address account, uint256[] memory _amounts, uint256[] memory _relative_release_time) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(_amounts.length == _relative_release_time.length, "Array with different sizes provided");
		for(uint256 i = 0; i < _amounts.length; i++) {
            insertLock(account, _amounts[i], _relative_release_time[i]);
        }
    }

	/**
	 * Retrieve the locks state for the account
	 */
    function locksOf(address account) public view returns(Locks[] memory) {
        return _locks[account];
    }

	/**
	 * Get the number of locks for an account
	 */
    function getLockNumber(address account) public view returns(uint256) {
        return _locks[account].length;
    }

	/**
	 * Release (mint) the amount of token locked
	 */
    function release(uint256 lock_id) public {
        require(_locks[msg.sender].length > 0, "No locks found for your account");
        require(_locks[msg.sender].length -1 >= lock_id, "Lock index too high");
		require(!_locks[msg.sender][lock_id].released, "Lock already released");
		require(block.timestamp > _locks[msg.sender][lock_id].release_time, "Lock not yet ready to be released");

		// refresh the amount of tokens locked
		total_locked_amount -= _locks[msg.sender][lock_id].locked;

		// mark the lock as realeased
		_locks[msg.sender][lock_id].released = true;

		// mint the tokens to the sender
		_mint(msg.sender, _locks[msg.sender][lock_id].locked);
		emit Released(msg.sender, _locks[msg.sender][lock_id].locked);
    }
}