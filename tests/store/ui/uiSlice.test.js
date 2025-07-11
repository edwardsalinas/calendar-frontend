import { onCloseDateModal, onOpenDateModal, uiSlice } from "../../../src/store/ui/uiSlice";

describe("pruebas en el uiSlice", () => {
    test("debe de regresar el estado por defecto", () => {
        expect( uiSlice.getInitialState() ).toEqual({ isDateModalOpen: false });
    });

    test('debe de cambiar el isDateModalOpen correctament', () => {
        let state = uiSlice.getInitialState();

        state = uiSlice.reducer( state, onOpenDateModal() );
        expect(state.isDateModalOpen).toBeTruthy();

        state = uiSlice.reducer( state, onCloseDateModal() );
        expect(state.isDateModalOpen).toBeFalsy();
        
    })
});
