import { StyleSheet, Text } from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'

export default function Index() {
	return (
		<SafeAreaView style={styles.container}>
			<Text>Hello world!</Text>
		</SafeAreaView>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent: 'flex-start',
		alignItems: 'center',
		paddingHorizontal: 12,
		paddingVertical: 24,
	},
})
