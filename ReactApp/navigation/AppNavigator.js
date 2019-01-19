import React from 'react';
import { createAppContainer, createSwitchNavigator } from 'react-navigation';

import MainTabNavigator from './MainTabNavigator';
import SignInScreen from '../screens/SignInScreen';

export default createAppContainer(createSwitchNavigator({
  Main: MainTabNavigator,
  SignIn: SignInScreen,
}));