import React from 'react';
import { Button, View } from 'react-native'

export default class SignInScreen extends React.Component {
    static navigationOptions = {
        title: 'Sign In',
      };

    render() {
        return (
            <View>
                <Button title="Please Sign In" />
            </View>
        );
    }
}