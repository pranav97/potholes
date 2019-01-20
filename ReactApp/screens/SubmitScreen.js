import React from 'react';
import { Button, View, StyleSheet } from 'react-native';

export default class SubmitScreen extends React.Component {
  static navigationOptions = {
    title: 'Submit',
  };

  render() {
    return (
      <View style={styles.container}>
        <Button 
          title="Submit" 
          onPress={() => this.props.navigation.navigate('SignIn')} 
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 15,
    backgroundColor: '#fff',
  },
});
