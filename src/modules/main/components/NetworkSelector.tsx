// Copyright 2015-2021 Parity Technologies (UK) Ltd.
// This file is part of Parity.

// Parity is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Parity is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Parity.  If not, see <http://www.gnu.org/licenses/>.

import React, { ReactElement, useContext, useState, useEffect } from 'react';
import { BackHandler, FlatList } from 'react-native';
import { useFocusEffect } from '@react-navigation/native';

import { NetworkCard } from 'components/NetworkCard';
import { SafeAreaViewContainer } from 'components/SafeAreaContainer';
import { IdentityHeading } from 'components/ScreenHeading';
import testIDs from 'e2e/testIDs';
import { AlertStateContext } from 'stores/alertContext';
import { NavigationAccountIdentityProps } from 'types/props';
import QrScannerTab from 'components/QrScannerTab';
import { getAllNetworks } from 'utils/native';

export default function NetworkSelector({
	navigation,
	route
}: NavigationAccountIdentityProps<'Main'>): React.ReactElement {
	const isNew = route.params?.isNew ?? false;
	const [networkList, setNetworkList] = useState<Array>([]);

	const { setAlert } = useContext(AlertStateContext);

	useEffect(() => {
		const fetchNetworkList = async function (): Promise<void> {
			const networkListFetch = await getAllNetworks();
			//This is where we check if the user has accepted TOC and PP
			if (Object.keys(networkListFetch).length === 0) {
				console.log('go to TOC');
				navigation.navigate('TermsAndConditions', { policyConfirmed: false });
			}
			setNetworkList(networkListFetch);
		};
		fetchNetworkList();
	}, []);

	// catch android back button and prevent exiting the app
	// TODO: this just doesn't work and nobody noticed, let's fix later
	// Maybe this is not the desired behavior?
	/*
	useFocusEffect(
		React.useCallback((): any => {
			const handleBackButton = (): boolean => {
				return false;
			};
			const backHandler = BackHandler.addEventListener(
				'hardwareBackPress',
				handleBackButton
			);
			return (): void => backHandler.remove();
		}, [])
	);*/

	const renderScreenHeading = (): React.ReactElement => {
		return <IdentityHeading title={'Select network'} />;
	};

	const onNetworkChosen = async (networkKey: string): Promise<void> => {
		navigation.navigate('PathsList', { networkKey });
	};

	const renderNetwork = (item): ReactElement => {
		return (
			<NetworkCard
				testID={testIDs.Main.networkButton + item.title}
				network={item.item}
				onPress={(): Promise<void> => onNetworkChosen(item.item.key)}
			/>
		);
	};

	return (
		<SafeAreaViewContainer>
			{renderScreenHeading()}
			<FlatList
				bounces={false}
				data={networkList}
				renderItem={renderNetwork}
				testID={testIDs.Main.chooserScreen}
			/>
			<QrScannerTab />
		</SafeAreaViewContainer>
	);
}
