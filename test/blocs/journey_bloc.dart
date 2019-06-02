import 'package:flutter_test/flutter_test.dart';
import 'package:inkstep/blocs/journey_bloc.dart';
import 'package:inkstep/blocs/journey_state.dart';
import 'package:inkstep/resources/journeys_repository.dart';
import 'package:mockito/mockito.dart';

class MockJourneysRepository extends JourneysRepository implements Mock {}

void main() {
  group('JourneyBloc', () {
    JourneyBloc journeyBloc;

    setUp(() {
      journeyBloc = JourneyBloc(journeysRepository: MockJourneysRepository());
    });

    test('initial state is unititialised', () {
      expect(journeyBloc.initialState, JourneyUninitialised());
    });

    /*test('add journey event with missing journey does nothing', () {
      expectLater(journeyBloc.state, neverEmits(anything));
//      expectLater(journeyBloc.state, emits(journeyBloc.initialState));

      journeyBloc.dispatch(AddJourney(null));
    });

    test('add journey event should emit the the current state plus the additional journey', () {
      Journey testJourney = Journey(
          availability: 'availability',
          deposit: 'deposit',
          size: 'size',
          artistName: 'artistName',
          name: 'name',
          position: 'position',
          mentalImage: 'mentalImage',
          email: 'email');
      expectLater(journeyBloc.state, emits(JourneyLoaded(journeys:  [testJourney])));

      journeyBloc.dispatch(AddJourney(testJourney));
    });*/
  });
}